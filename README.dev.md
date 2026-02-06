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
The base URL is currently hardcoded in `lib/api/global_api.dart`:
- **Current Domain:** `https://tele.petsmore.com.my/api`
- **Legacy/Internal Domain:** `https://sys.senheng.com.my/shmanagement_apps/telemarketing/` (Commented out)

## 📦 Building for Production

### Android
```bash
flutter build apk --release
# OR
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Code Standards
- Use `AppColors` and `AppTextStyles` for all UI elements.
- Use `responsive_sizer` (`.h`, `.w`, `.sp`) for layout dimensions to ensure responsiveness.
- Wrap API calls in `try-catch` blocks or handle them within Riverpod providers.
