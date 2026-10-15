# Architecture

Petsmore Telemarketing App is a Flutter client (Android and iOS) for a PHP/JSON backend. This document covers how the code is layered, how data moves through it, and how authentication, roles and navigation work. The endpoint-by-endpoint reference is in [README.dev.md](README.dev.md).

## Tech stack

| Concern | Choice |
| :--- | :--- |
| UI | Flutter (Material 3), Poppins font, `responsive_sizer`, portrait only |
| State | `flutter_riverpod` 2.x, mostly `ChangeNotifierProvider` with a few `StateProvider` / `StateNotifierProvider` |
| Service locator | `get_it` (`lib/services/get_it.dart`) |
| HTTP | `package:http`, wrapped by `APIManager` |
| Persistence | `shared_preferences`, wrapped by `GetSharedPreferences` |
| Device features | `url_launcher` (dial), `share_whatsapp` / `share_plus` / `send_message` (sharing), `background_downloader` + `path_provider` + `external_path` (media download), `image_picker` (profile photo), `permission_handler`, `fluttertoast` |

## Layers

```
Screen / Widget        lib/screen, lib/widgets
   │  ref.watch / ref.read
   ▼
Provider               lib/provider        (ChangeNotifier: isFetching, failure, responseData, clearData)
   │  calls
   ▼
Feature API            lib/api/*_api.dart  (builds URL from GlobalAPI, returns Map or the error)
   │  calls
   ▼
APIManager             lib/api/api_manager.dart (http + timeout + status mapping + JSON clean-up)
   │
   ▼
PHP backend            GlobalAPI.apidomain + /<endpoint>.php
```

Shared across every layer:

- `GetSharedPreferences` holds the session (staff code, role, name, cached lists).
- `getIt` services: `ErrorMessageService` (last user-facing error), `OpenDialogService` (stops dialogs stacking), `UserLoginService` (live role, a `ChangeNotifier`).
- `config/global.dart` holds the design tokens.
- `global_function/` has the logout, dialog and debug-print helpers.

### Network layer

- **`GlobalAPI`** (`lib/api/global_api.dart`) has `apidomain = Env.apiBaseUrl` plus one field per endpoint. The base URL comes from the build flavor (see [Environments](#environments-and-flavors)).
- **`APIManager`** (`lib/api/api_manager.dart`) offers GET/POST/PUT/PATCH/DELETE variants. Almost all traffic goes through `getAPICall(url)`, a GET with query parameters and a 30 s timeout. `_response()`:
  - returns `{}` for an empty body;
  - drops anything before the first `{`, because PHP warnings can come ahead of the JSON;
  - returns the decoded body for 400/404 and throws `UnauthorisedException` / `ServerErrorException` / `FetchDataException` for 401/403/500/other;
  - writes a human-readable message to `ErrorMessageService` for every failure path.
- **Feature API classes** (`LoginAPI`, `HomeAPI`, `CallSummaryAPI`, `ConvertedAPI`, `SettingsAPI`, `StaffAPI`, `TelemarketerAssignAPI`, `TelemarketerCampaignAssignAPI`) each build a URL, call `APIManager`, and usually **catch the exception and return it (or `e.toString()`) as the result**. Providers therefore check `res['status'] == '1'` and handle a non-Map result defensively.
- **Response contract:** `{ "status": "1" | "0", "LIST": {...} | [...], ... }`. Keys are uppercase backend names, and there are no typed models.

### State layer

Global providers are declared at the top of `lib/main.dart`:

| Provider | Class | Feeds |
| :--- | :--- | :--- |
| `loginProvider` | `LoginProvider` | Login screen, session bootstrap |
| `homeProvider` | `HomeProvider` | Home dashboard (campaigns, call-status counts) |
| `callSummaryProvider` | `CallSummaryProvider` | Call Summary list + campaign filter |
| `callSummaryDetailProvider` | `CallSummaryDetailProvider` | Call Details: call log, WhatsApp, SMS, name card, images/audio/video, remarks |
| `campaignProvider` | `GetCampaignProvider` | Campaign lists |
| `telemarketingAssignProvider` | `TelemarketingAssignProvider` | Outlet → telemarketer assignment |
| `telemarketingCampaignAssignProvider` | `TelemarketingCampaignAssignProvider` | Outlet + campaign → telemarketer group assignment |
| `convertedProvider` | `ConvertedProvider` | Converted outlets/customers/sales orders |
| `settingProvider` | `SettingProvider` | Profile settings, `refreshUserRole()` |
| `searchProvider` | `SearchProvider` | Search/filter text |
| `userRoleProvider` | `UserLoginService` (from GetIt) | Role-driven navigation |

These are also declared, in `lib/provider/bottom_nav_provider.dart`: `bottomNavNotifierProvider` (selected tab index/name) and `initialTabIndexProvider` (the sub-tab Call Summary opens on).

Every data provider follows the same pattern: set `_isFetching` and `notifyListeners()`, call the API, store `responseData` and derived lists, set `failure` if something went wrong, and expose `clearData()` for logout.

## App lifecycle

### Startup

1. `main()` reads `last_login` from SharedPreferences, records the platform (`android`/`ios`), registers the GetIt services, and runs `MyAppWithInitialRoute(initialRoute: '/load')` inside a `ProviderScope`.
2. `Load` (`lib/screen/load.dart`) shows the logo for 2 s, then:
   - **not logged in** → `Splash` → `Login`;
   - **logged in** → reads `userPosition`, pushes it into `UserLoginService`, and replaces the route with `BottomNavBarWrapper(child: Home())`. If the role is empty it forces a logout.

### Login

`Login` → `LoginProvider.fetchLogin()` → `GET login.php?username=&password=`. If `status == '1'`, `LIST.{ID, CODE, NAME, POSITION, HQSTAFF}` is written to SharedPreferences and `POSITION` is pushed to `UserLoginService`, which rebuilds the navigation for that role.

### Logout

`AppLogout.logout()` clears SharedPreferences, calls `clearData()` on each data provider, resets `UserLoginService` to `''`, and clears the navigation stack back to `Login`.

## Roles and navigation

The role (`userPosition`) is the single switch for what a user can see:

| Role | Tabs (index order) |
| :--- | :--- |
| `TM`, `AM` | 0 Home · 1 Telemarketer (`Outlet`) · 2 Call Summary · 3 Converted · 4 Settings |
| `STAFF` | 0 Home · 1 Call Summary · 2 Settings |
| `''` | Bottom bar renders `Login` |

`BottomNavBarWrapper` (`lib/widgets/bottom_navigation_bar.dart`) is the app shell:

- It is a `PageView` with `NeverScrollableScrollPhysics`. The pages come from `_buildNavBarChildren()` and depend on the role.
- A tap sets `bottomNavNotifierProvider`. A `ref.listen` on that provider pops any pushed routes and jumps the `PageView`, which lets other screens switch tabs by setting the provider.
- Tapping Call Summary (index 2 for TM/AM, 1 for STAFF) resets `initialTabIndexProvider` and the campaign filter to `'ALL'`.
- `settingProvider.refreshUserRole()` runs when the shell is created and on every tab tap. It calls `staff_detail.php`, and if `POSITION` has changed on the server it updates SharedPreferences and `UserLoginService`, so the navigation rebuilds without a re-login.

`home.dart` and `settings.dart` also branch on the role. Any change to tab order has to be made in all three files.

Below the tabs, detail screens are pushed with `MaterialPageRoute` (or with the named routes in `main.dart`): `CallDetails`, `Campaign`, `CampaignTelemarketer`, `Telemarketer`, `Converted2`, `ConvertedDetail`, `Notifications`.

## Feature map

| Feature | Screens | Provider | API class | Main endpoints |
| :--- | :--- | :--- | :--- | :--- |
| Auth | `load`, `splash`, `login` | `LoginProvider` | `LoginAPI` | `login.php` |
| Dashboard | `home` | `HomeProvider` | `HomeAPI` | `home_3.php` |
| Call list | `call_summary`, `remarks_tab` | `CallSummaryProvider` | `CallSummaryAPI` | `call_summary_2.php` |
| Customer contact | `call_details` + `share_images_modal`, `business_card_modal`, `download_modal` | `CallSummaryDetailProvider` | `CallSummaryAPI` | `call_detail_2.php`, `call_detail_calllog_submit_3.php`, `call_detail_whatsapp.php`, `whatsapp_log_submit_new.php`, `sms_sharing.php`, `call_detail_namecard.php`, `call_detail_share_new.php`, `get_audio_list.php`, `get_video_list.php`, `call_detail_submit.php` |
| Outlet assignment (TM/AM) | `outlet`, `telemarketer` | `TelemarketingAssignProvider` | `telemarketer_assign.dart` | `tele_outlet.php`, `tele_outlet_staff4.php`, `tele_outlet_staff_submit.php` |
| Campaign assignment (TM/AM) | `campaign`, `campaign_telemarketer` | `TelemarketingCampaignAssignProvider`, `GetCampaignProvider` | `telemarketer_campaign_assign.dart` | `tele_outlet_campaign.php`, `tele_outlet_staff_group*.php` |
| Converted (TM/AM) | `converted`, `converted2`, `converted_detail` | `ConvertedProvider` | `ConvertedAPI` | `tele_converted*.php` |
| Settings / profile | `settings` | `SettingProvider` | `SettingsAPI`, `StaffAPI` | `call_setting.php`, `call_setting_update.php` (multipart, base64 photo), `staff_detail.php` |

## Platform integration

- **Calling:** the app dials with `url_launcher` (`tel:`), and the outcome is posted to the call-log endpoint.
- **WhatsApp / SMS sharing:** uses `share_whatsapp`, `share_plus` and `send_message`. On iOS, `LSApplicationQueriesSchemes` needs `https` so WhatsApp can be detected (see `TESTFLIGHT_CHECKLIST.md`).
- **Media download:** `background_downloader` saves campaign images, audio and video to a public directory found with `external_path` / `path_provider`. Storage and photo permissions go through `permission_handler`.
- **Identifiers:** these are set per flavor (see below). The privacy manifest is at `ios/Runner/PrivacyInfo.xcprivacy`.
- **Branding:** the launcher icon is `assets/logo/senwave.png` and the splash image is `assets/logo/sh-crm-logo.png`, both configured in `pubspec.yaml`.

## Environments and flavors

There are two flavors, `staging` and `production`. A build needs the native flavor and the matching Dart env file:

```bash
flutter run --flavor staging --dart-define-from-file=env/staging.json
flutter build ipa --release --flavor production --dart-define-from-file=env/production.json
```

| Layer | Where | What varies |
| :--- | :--- | :--- |
| Dart | `env/<flavor>.json` → `lib/config/env.dart` (`Env`) | `FLAVOR`, `API_BASE_URL`, `APP_NAME` |
| Android | `android/app/build.gradle` `productFlavors` | `applicationIdSuffix ".staging"`, `resValue app_name` |
| iOS | `project.pbxproj` configurations `{Debug,Release,Profile}-{flavor}`, schemes `staging` / `production`, `ios/Flutter/<Config>-<flavor>.xcconfig`, `Podfile` | `PRODUCT_BUNDLE_IDENTIFIER` (`com.petsmore.staging.telemarketings` / `com.petsmore.telemarketings`), `APP_DISPLAY_NAME` |

Safety rails:

- `Env.validate()` runs before `runApp`. It refuses to start if the env file is missing, if its `FLAVOR` differs from the native `appFlavor`, or if the base URL isn't https.
- Staging builds have their own app ID and name (so they install alongside production) and show a "STAGING" corner banner.
- The env files contain only public URLs and labels. **Never put secrets in them**, because dart-define values are compiled into the binary.

## Known constraints and tech debt

- The Android production `applicationId` is still the template `com.example.petsmore_tele_app`. Changing it creates a new Play Store listing.
- Credentials and all writes go over `GET` query strings, because the backend expects that.
- Responses are untyped `Map`s and there is no model layer, so a key typo fails at runtime.
- Error handling is uneven: some API classes return the exception object, others return `null`/`{}`.
- `package:http` is used without being declared in `pubspec.yaml`.
- There are no automated tests, even though CI runs `flutter test`.
- The role is checked with string comparisons spread across several files. Tab indices are hard-coded per role.
