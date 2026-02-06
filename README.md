# PetsMore Tele App (petsmore_tele_app)

A Flutter-based telemarketing application designed for PetsMore to manage telemarketing campaigns, track call logs, and handle customer conversions.

## 🚀 Overview

This application serves as a comprehensive tool for telemarketers to:
- Access and manage assigned campaigns.
- Log calls and WhatsApp interactions directly from the app.
- View detailed call summaries and customer information.
- Track converted sales and approved orders.
- Access campaign resources like audio, video, and images.

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [Riverpod](https://riverpod.dev/)
- **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it)
- **Networking:** [http](https://pub.dev/packages/http)
- **UI & Layout:** [responsive_sizer](https://pub.dev/packages/responsive_sizer) for multi-device support.
- **Local Storage:** [shared_preferences](https://pub.dev/packages/shared_preferences)

## 📦 Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.4.4)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code with Flutter extensions

## ⚙️ Getting Started

1.  **Clone the repository:**
    ```bash
    git clone [repository-url]
    cd petsmore_tele_app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    flutter run
    ```

## 🏗 Project Structure

- `lib/api`: API managers and endpoint configurations.
- `lib/config`: Global UI configuration (colors, text styles, dimensions).
- `lib/provider`: State management using Riverpod.
- `lib/screen`: UI screens and page layouts.
- `lib/services`: Singleton services and business logic.
- `lib/widgets`: Reusable UI components.

## 📄 Documentation

For detailed developer information, including architecture details and internal workflows, please refer to [README.dev.md](./README.dev.md).
