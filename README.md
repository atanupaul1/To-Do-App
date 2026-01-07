# Flutter Pro To-Do App 🚀

A professional-grade To-Do application built to demonstrate clean architecture, reactive state management, and REST API integration in Flutter.

## 📱 Project Preview

<p align="center">
  <img src="https://github.com/user-attachments/assets/18d49ddb-a9a9-4530-a632-0689553982fc" width="30%" alt="To Do List" />
  <img src="https://github.com/user-attachments/assets/4d09bb33-d369-4e0f-b43d-7193efa62611" width="30%" alt="Add New Task" />
  <img src="https://github.com/user-attachments/assets/0678c1f1-9180-44ca-a7aa-0d55dcbc223f" width="30%" alt="Update Existing Task" />
</p>

## ✨ Features
- **Reactive State Management**: Utilizes GetX (`.obs` and `Obx`) for high-performance UI updates.
- **REST API Integration**: Fetches initial data from JSONPlaceholder using the `http` package.
- **Full CRUD Operations**: Support for Creating, Reading, Updating, and Deleting tasks.
- **Clean MVC Architecture**: Strictly separated into `models`, `screens`, `controllers`, and `services`.
- **Modern UI/UX**: Implements Material 3 design, custom Alert Dialogs, and SnackBar notifications.

## 🛠️ Tech Stack
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: GetX
- **Networking**: Http package (REST API)

## 🏗️ Architecture Flow


The app follows a decoupled logic flow:
1. **Service**: Handles the raw HTTP calls.
2. **Model**: Parses JSON data into Dart objects.
3. **Controller**: Manages the state and business logic using GetX.
4. **View**: Displays the data and listens for updates via `Obx`.

## 🚀 Getting Started
1. Clone this repository:
   `git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git`
2. Install dependencies:
   `flutter pub get`
3. Run the app:
   `flutter run`
