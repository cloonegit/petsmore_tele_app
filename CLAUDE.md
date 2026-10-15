# CLAUDE.md

Guidance for Claude Code when working in this repository. For the system design, see [ARCHITECTURE.md](ARCHITECTURE.md). For the endpoint list and build notes, see [README.dev.md](README.dev.md).

## Project

**Petsmore Telemarketing App** (`petsmore_tele_app`), a Flutter app for Android and iOS. Telemarketers use it to work through campaign call lists, log calls, WhatsApp and SMS contact, share campaign media, and track converted sales. Managers also use it to assign outlets and campaigns to telemarketers. The backend is a set of PHP endpoints (`*.php`) that return JSON.

## Commands

```bash
flutter pub get
flutter analyze
# Every run/build needs BOTH --flavor and the matching env file
flutter run --flavor staging --dart-define-from-file=env/staging.json
flutter run --flavor production --dart-define-from-file=env/production.json
flutter build appbundle --release --flavor production --dart-define-from-file=env/production.json
flutter build ipa --release --flavor production --dart-define-from-file=env/production.json
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

- Flavors are `staging` and `production`. See "Environments & flavors" below.
- Run `flutter analyze` before you say a change is done. CI (`.github/workflows/flutter_ci.yml`) runs `analyze`, `test` and a debug APK build on pushes and PRs to `main`.
- The repo has no `test/` directory, so `flutter test` has nothing to run. Add tests under `test/`.
- iOS release steps are in `TESTFLIGHT_CHECKLIST.md`. Open `ios/Runner.xcworkspace`, not the `.xcodeproj`.

## Layout

```
lib/
  main.dart          App entry, global Riverpod providers, named routes, theme
  api/               One *API class per feature + APIManager (HTTP) + GlobalAPI (URLs)
  provider/          ChangeNotifier state per feature (Riverpod-wrapped)
  screen/            Full pages
  widgets/           Reusable widgets, modals and the bottom navigation shell
  services/          GetIt singletons, SharedPreferences wrapper, debouncer
  global_function/   Logout, debug print, dialogs, back button
  config/global.dart AppColors, AppTextStyles, AppDimensions
```

## Conventions to follow

- **Adding an endpoint:** add the URL to `GlobalAPI` in `lib/api/global_api.dart`, add a method to the feature's `*API` class that calls `APIManager().getAPICall(url)`, then call it from the feature's `ChangeNotifier` provider. Screens never call `*API` classes directly.
- **Providers:** global `ChangeNotifierProvider`s are declared in `lib/main.dart` (e.g. `homeProvider`, `callSummaryProvider`). New feature state should follow the same pattern. Each provider has `isFetching`, `failure` and `responseData`, plus a `clearData()` method. If you add a provider that holds user data, also clear it in `AppLogout.logout` (`lib/global_function/app_logout.dart`).
- **Responses** are untyped `Map`s keyed by the backend's field names (`res['status'] == '1'`, `res['LIST']['POSITION']`). There are no model classes. Keep the existing key names, and treat `status` as the string `'1'` or `'0'`, not as a bool.
- **Session data** goes through `GetSharedPreferences` (`lib/services/get_sharedpreferences.dart`). Keys are `userCode` (the `staffcode` sent to most endpoints), `userPosition` (the role), `userID`, `userName`, `userHQStaff` and `last_login`.
- **Styling:** use `AppColors`, `AppTextStyles` and `AppDimensions` from `lib/config/global.dart`. Size layouts with `responsive_sizer` (`.h`, `.w`, `.sp`, `Adaptive.h()`). The font is Poppins.
- **Logging:** use `AppDebug().printDebug(msg: ...)`. It prints in debug builds only. Don't use `print`.
- **Errors:** `APIManager` maps failures to `CustomException` subclasses and stores a user-facing message in `getIt<ErrorMessageService>()`. Most `*API` methods catch and return the error instead of rethrowing, so providers have to check the shape of what they get back.
- **Dialogs:** use `showCustomDialog` / `showLoadingDialog` from `lib/global_function/`.

## Roles (important)

The user's role is `userPosition`, which comes from login or `staff_detail.php`:

- `TM` / `AM`: 5 tabs (Home, Telemarketer/Outlet, Call Summary, Converted, Settings)
- `STAFF`: 3 tabs (Home, Call Summary, Settings)

The live role lives in `UserLoginService` (a GetIt `ChangeNotifier`), and the UI reads it through `userRoleProvider`. `BottomNavBarWrapper` (`lib/widgets/bottom_navigation_bar.dart`) builds its pages from the role and calls `settingProvider.refreshUserRole()` when it starts and on every tab tap. **Tab indices depend on the role.** Call Summary is index 2 for TM/AM and index 1 for STAFF. When you change tabs or role-gated UI, update every place that branches on the role: `bottom_navigation_bar.dart`, `home.dart` and `settings.dart`.

## Environments & flavors

| | staging | production |
| :--- | :--- | :--- |
| Env file | `env/staging.json` | `env/production.json` |
| API base URL | `https://staging.senwave.com.my/petsmore_telemarketing_api` | `https://tele.petsmore.com.my/api` |
| iOS bundle ID | `com.petsmore.staging.telemarketings` | `com.petsmore.telemarketings` |
| Android applicationId | `com.example.petsmore_tele_app.staging` | `com.example.petsmore_tele_app` |
| App name | Petsmore Telemarketing Staging (plus a "STAGING" corner banner) | Petsmore Telemarketing |

- `lib/config/env.dart` (`Env`) reads `FLAVOR`, `API_BASE_URL` and `APP_NAME` from the env file. `GlobalAPI.apidomain` is `Env.apiBaseUrl`, so **never hardcode or hand-edit the base URL**. To change a URL, or to add a new per-environment value, edit both env JSON files and `Env`.
- `Env.validate()` runs first in `main()`. It throws if the env file is missing, if its `FLAVOR` doesn't match the native `--flavor` (`appFlavor`), or if the URL isn't https. Running with a mismatched or missing flavor/env file crashes on purpose.
- Android: `productFlavors` in `android/app/build.gradle`. The app name comes from `resValue` → `@string/app_name`.
- iOS: build configurations are `{Debug,Release,Profile}-{staging,production}`, with schemes `staging` and `production` (the `Runner` scheme was removed). Bundle ID and `APP_DISPLAY_NAME` are set per configuration in `project.pbxproj`. `Info.plist` uses `$(APP_DISPLAY_NAME)`. Each configuration's base xcconfig is `ios/Flutter/<Config>-<flavor>.xcconfig`, and the `Podfile` maps all six configurations. If you add a configuration, update all of these and run `pod install`.
- Build iOS releases with `flutter build ipa ...` and not by archiving straight from Xcode. Xcode reuses the dart-defines from the last `flutter` command (`Generated.xcconfig`), so an Xcode archive can pick up the wrong env.

## Gotchas

- **Most endpoints are `GET` with query-string parameters**, and that includes login (`username`/`password`) and submits. Follow the existing pattern unless the backend changes. Don't log credentials in new code.
- **`APIManager._response` strips any text before the first `{`**, because the PHP backend sometimes prints warnings ahead of the JSON. Don't remove this.
- `package:http` is imported but is not declared in `pubspec.yaml`; it only comes in transitively. Add it to `dependencies` if you touch networking.
- Navigation mixes named routes (`main.dart`) with direct `MaterialPageRoute` pushes. The startup flow is `/load` → `Load`, which checks `last_login`, then goes to `Splash`/`Login` or to `BottomNavBarWrapper(child: Home())`.
- Bump the version in `pubspec.yaml` (`version: x.y.z+build`) for each store build.
- `.DS_Store` files are tracked and show up as modified. Don't commit them.
