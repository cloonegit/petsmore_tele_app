# Developer Documentation

This document provides technical details about the project's architecture, patterns, and development workflows for the PetsMore Tele App.

## 🏗 Architecture & Design Patterns

### 1. State Management (Riverpod + ChangeNotifier)
The app uses **Riverpod** as the state management wrapper, primarily utilizing `ChangeNotifierProvider` for modern yet familiar state handling. Providers are located in `lib/provider/`.
- Providers are defined globally in `lib/main.dart` or within their respective files.
- UI screens consume these providers via `ref.watch()` or `ref.read()`.
- Logic for data updates resides within the `ChangeNotifier` classes located in `lib/provider/`.

### 2. Networking & API
API interactions are centralized in `lib/api/`.
- **`APIManager`**: A wrapper around the `http` package that handles common status codes, error logging, and JSON decoding.
- **`GlobalAPI`**: Contains the base URL (`apidomain`) and all endpoint paths.
- To add a new endpoint, update `lib/api/global_api.dart` and create a corresponding service or provider.

### 3. Dependency Injection (GetIt)
We use `GetIt` for service location. Services are initialized in `lib/services/get_it.dart`.
- Example: `getIt<ErrorMessageService>()` is used for global error handling.

### 4. UI Configuration
UI constants are managed in `lib/config/global.dart`.
- **`AppColors`**: Define all theme colors here. Avoid hardcoding hex values in screens.
- **`AppTextStyles`**: Centralized Poppins text styles.
- **`AppDimensions`**: Standard padding, margins, and border radii.

## 📡 API Documentation

All API endpoints are centralized in `lib/api/global_api.dart`. The base URL comes from the flavor's env file (`env/staging.json` or `env/production.json`).

### 1. Authentication
- **Login**: `GET /login.php`
  - Parameters: `username`, `password`
  - File: `lib/api/login_api.dart`

### 2. Home & Dashboard
- **Home Data**: `GET /home_3.php`
  - Parameters: `staffcode`
  - File: `lib/api/home_api.dart`

### 3. Call Summary & Interaction
- **Call Summary**: `GET /call_summary_2.php?staffcode={staffcode}`
- **Call Detail**: `GET /call_detail_2.php?platform={type}&staffcode={staffcode}&cid={cid}`
- **WhatsApp Detail**: `GET /call_detail_whatsapp.php?staffcode={staffcode}&cid={cid}`
- **Business Card**: `GET /call_detail_namecard.php?staffcode={staffcode}&cid={cid}`
- **Campaign Images**: `GET /call_detail_share_new.php?staffcode={staffcode}&cid={cid}`
- **Campaign Audio**: `GET /get_audio_list.php?campaign_id={id}`
- **Campaign Video**: `GET /get_video_list.php?campaign_id={id}`
- **WhatsApp Log Submit**: `GET /whatsapp_log_submit_new.php`
  - Parameters: `staffcode`, `cid`, `campaign_id`, `platform`, `count_whatsapp_log`
- **SMS Sharing Log**: `GET /sms_sharing.php?number={num}&message={msg}`
- **Submit Remarks**: `GET /call_detail_submit.php`
  - Parameters: `platform`, `staffcode`, `cid`, `callstatus`, `remark`
- **File**: `lib/api/call_summary_api.dart`

### 4. Converted Sales
- **Outlet List**: `GET /tele_converted.php?staffcode={staffcode}`
- **Customer List**: `GET /tele_converted_customer.php?outletcode={outlet}`
- **Approached List**: `GET /tele_converted_salesorder.php?outletcode={outlet}`
- **Approached Detail**: `GET /tele_converted_call_detail.php?cid={cid}`
- **Approached Submit**: `GET /tele_converted_call_detail_submit.php`
  - Parameters: `cid`, `remark`, `son_type`, `son`
- **File**: `lib/api/converted_api.dart`

### 5. Telemarketer Assignment
- **General Assignment**:
  - Outlet List: `GET /tele_outlet.php?staffcode={staffcode}`
  - Staff List: `GET /tele_outlet_staff4.php?staffcode={staffcode}&outlet={outlet}`
  - Assign: `GET /tele_outlet_staff_submit.php?staffcode={staffcode}&telemarketer={assign}&outlet={outlet}`
  - File: `lib/api/telemarketer_assign.dart`
- **Campaign Assignment**:
  - Outlet List: `GET /tele_outlet_campaign.php`
  - Staff Group: `GET /tele_outlet_staff_group.php?staffcode={staffcode}&outlet={outlet}&campaignid={id}`
  - Assign: `GET /tele_outlet_staff_group_submit.php?staffcode={staffcode}&telemarketer={assign}&outlet={outlet}&campaignid={id}`
  - File: `lib/api/telemarketer_campaign_assign.dart`

### 6. Settings
- **Get Settings**: `GET /call_setting.php?staffcode={staffcode}`
- **Update Settings**: `POST /call_setting_update.php` (Multipart)
  - Fields: `staffName`, `staffCode`, `staffContact`, `outletAddress`, `outletContact`, `profile_pic` (base64)
- **File**: `lib/api/settings_api.dart`

## 📁 Key Directories

| Directory | Responsibility |
| :--- | :--- |
| `lib/api` | API client, exceptions, and endpoint definitions. |
| `lib/config` | UI tokens (Colors, Fonts, Sizes). |
| `lib/global_function` | Utility functions used across the app. |
| `lib/provider` | Riverpod providers for state. |
| `lib/screen` | Feature-based screens/pages. |
| `lib/services` | Logic-heavy classes and third-party wrappers. |
| `lib/widgets` | Atom-level and molecule-level reusable widgets. |

## 🛠 Common Development Commands

### Cleanup and Dependency Refresh
```bash
flutter clean
flutter pub get
```

### Assets and Icons
If you change the app icon or splash screen:
```bash
# Generate launcher icons
flutter pub run flutter_launcher_icons

# Splash screen configuration is in pubspec.yaml under flutter_native_splash
# (If using flutter_native_splash command)
flutter pub run flutter_native_splash:create
```

## 🔒 Environment Management
There are two flavors: `staging` and `production`. Each has an env file in `env/` that sets the API base URL and app name. Always pass both `--flavor` and the matching env file:
```bash
flutter run --flavor staging --dart-define-from-file=env/staging.json
flutter run --flavor production --dart-define-from-file=env/production.json
```
The app refuses to start if the flavor and env file don't match. See `ARCHITECTURE.md` → Environments and flavors.

## 📦 Building for Production

### Android
```bash
flutter build appbundle --release --flavor production --dart-define-from-file=env/production.json
```

### iOS
```bash
flutter clean
   flutter pub get
flutter build ipa --release --flavor production --dart-define-from-file=env/production.json
```
open ios/Runner.xcworkspace

## 🧪 Releasing iOS Staging (TestFlight)

The staging app is a separate app: bundle ID `com.petsmore.staging.telemarketings`, display name "Petsmore Telemarketing Staging", pointed at the staging API. It installs alongside production.

### One-time setup
1. **Apple Developer → Identifiers:** register the App ID `com.petsmore.staging.telemarketings` under team `3648KQBLF4`. Enable the same capabilities as the production app.
2. **App Store Connect → Apps → +:** create a new app with that bundle ID (for example, "Petsmore Telemarketing Staging"). TestFlight needs an app record, even though this app is never submitted for review.
3. **Signing:** the project uses automatic signing. Open `ios/Runner.xcworkspace`, select the **staging** scheme, go to **Runner → Signing & Capabilities**, and check that the `Release-staging` configuration resolves a profile for the staging bundle ID.

### Each release
1. **Bump the build number** in `pubspec.yaml` (`version: x.y.z+N`). `N` must be higher than the last staging upload. Staging and production keep separate build histories in App Store Connect.
2. **Build the IPA** from the project root. Always use the Flutter CLI, so the staging env file is compiled in:
   ```bash
   flutter clean
   flutter pub get
   flutter build ipa --release --flavor staging --dart-define-from-file=env/staging.json
   ```
   This produces:
   - Archive: `build/ios/archive/Runner.xcarchive`
   - IPA: `build/ios/ipa/*.ipa`
3. **Check the build before uploading:**
   ```bash
   plutil -extract CFBundleIdentifier raw build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app/Info.plist
   ```
   The output must be `com.petsmore.staging.telemarketings`.
4. **Upload** using one of these:
   - **Xcode Organizer:** run `open build/ios/archive/Runner.xcarchive`, then click **Distribute App** → **App Store Connect** → **Upload**.
   - **Transporter app:** drag in the `.ipa` from `build/ios/ipa/`.
   - **Command line:** use an App Store Connect API key. Keep the `.p8` file in `~/.appstoreconnect/private_keys/`, never in this repo.
     ```bash
     xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey <KEY_ID> --apiIssuer <ISSUER_ID>
     ```
5. **TestFlight:** once processing finishes (usually 5–30 minutes), add the build to your internal testing group. Testers will see the **STAGING** corner banner in the app.

> ⚠️ Don't use **Product → Archive** directly in Xcode. Xcode reuses the dart-defines from the last `flutter` command (`ios/Flutter/Generated.xcconfig`), so the archive can contain the wrong env. The app's startup check would then crash it on launch. Always archive with `flutter build ipa` as shown above.

## 🤝 Code Standards
- Use `AppColors` and `AppTextStyles` for all UI elements.
- Use `responsive_sizer` (`.h`, `.w`, `.sp`) for layout dimensions to ensure responsiveness.
- Wrap API calls in `try-catch` blocks or handle them within Riverpod providers.

cd ios
open Runner.xcworkspace
