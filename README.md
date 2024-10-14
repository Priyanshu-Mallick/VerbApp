
# Verbb Admin & School Admin App

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
  - [Verbb Admin App](#verbb-admin-app)
  - [School Admin App](#school-admin-app)
- [Installation](#installation)
- [API Integration](#api-integration)
  - [Verbb Admin APIs](#verbb-admin-apis)
  - [School Admin APIs](#school-admin-apis)
- [State Management](#state-management)
- [Authentication](#authentication)
- [Shared Preferences](#shared-preferences)
- [Usage](#usage)
  - [Verbb Admin App](#verbb-admin-app-usage)
  - [School Admin App](#school-admin-app-usage)
    
## Overview
The **Verbb Admin** and **School Admin** applications form a comprehensive solution for school management and teacher registrations. The Verbb Admin is used by administrators to manage schools and teacher information, while the School Admin is designed for school admins to log in, manage their profiles, and check their registration status.

## Features
### Verbb Admin
- **Login Authentication**: Admin login with email and password.
- **Manage Schools**: Ability to add, view, and update schools.
- **Add Teachers**: Manage teacher data, including email verification.
- **Backend Integration**: RESTful APIs for login and school management.

### School Admin
- **Google Authentication**: Admins can log in using their Google accounts.
- **User Session Management**: Keeps users logged in between sessions using shared preferences.
- **Check Registration**: Verifies if a school admin is already registered by the Verbb Admin.
- **Backend Integration**: Full integration with backend services to verify users and manage their login.

## Tech Stack
- **Flutter**: Mobile application framework for cross-platform apps.
- **Firebase**: Used for Google Sign-In (School Admin) and managing user authentication.
- **REST APIs**: Backend services used for authentication, verifying school admins, and managing school data.
- **Provider**: For state management across both apps.
- **Shared Preferences**: Used for session management to persist user data locally.
- **HTTP/IO Client**: For making HTTP requests and managing API interactions.

## Project Structure
### Verbb Admin App
```bash
verbb_admin_app/
├── controllers/         # Contains all the state management controllers
│   ├── auth_controller.dart
│   ├── home_controller.dart
├── models/              # Models like UserModel and SchoolModel
├── services/            # API and SharedPreference services
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── shared_preference_service.dart
├── views/               # UI pages like Login, Home, Add Schools
│   ├── home_view.dart
│   ├── login_view.dart
│   ├── widgets/         # Widgets like AddSchoolBottomSheet
├── main.dart            # Main entry point for Verbb Admin App
```

### School Admin App
```bash
school_admin_app/
├── controllers/         # AuthController for managing state
├── models/              # Models like UserModel
├── services/            # API and SharedPreference services
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── shared_preference_service.dart
├── views/               # UI pages like Login, Home, NotRegistered
│   ├── home_view.dart
│   ├── login_view.dart
│   ├── not_registered_view.dart
├── main.dart            # Main entry point for School Admin App
firebase_options.dart    # Firebase configuration for Google Sign-In
```

## Installation

### Prerequisites
- **Flutter SDK**: Install Flutter SDK from the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- **Firebase**: Ensure Firebase is set up for Google Sign-In in the School Admin App.
- **Backend API**: Ensure the backend API is up and running for school management.

### Steps to Run Both Apps

1. Clone the repositories:
    ```bash
    git clone https://github.com/your-repo/verbb-admin-app.git
    git clone https://github.com/your-repo/school-admin-app.git
    ```

2. Navigate to each directory and install the required dependencies:
    ```bash
    flutter pub get
    ```

3. Set up Firebase:
    - Add the `google-services.json` for Android and `GoogleService-Info.plist` for iOS into their respective folders for **School Admin App**.

4. Configure the Backend API:
    - Ensure the backend service is running.
    - Update the `baseUrl` in `lib/services/api_service.dart` to point to your backend's URL.

5. Run each app on your emulator or device:
    ```bash
    flutter run
    ```

## API Integration
### Verbb Admin APIs
- **POST `/token`**: Admin login with email and password.
- **POST `/add_school`**: Allows admins to add schools and teacher details.
- **GET `/get_schools`**: Fetches the list of schools added by the admin.

### School Admin APIs
- **POST `/schools/verify`**: Verifies whether the user's email is registered in the system.
- **Google Authentication**: Uses Firebase for Google sign-in, and then verifies the email using the backend API.

API calls in both apps are handled by `ApiService` and token-based authorization is added to secured endpoints. Shared preferences store the `access_token` received from the API for persistent login sessions.

## State Management
Both apps use the **Provider** package for state management.

### Controllers
1. **AuthController**:
    - Manages user login, session persistence, and state changes for login.
    - Handles the login and Google sign-in logic (in the School Admin app).

2. **HomeController** (for Verbb Admin):
    - Manages the addition of schools, fetching school details, and state changes related to school management.

## Authentication
- **Verbb Admin**: Email-based login using REST API.
- **School Admin**: Google Sign-In via Firebase, followed by a check with the backend API to ensure the admin is registered.
- After successful login, user data is stored in shared preferences to keep the session alive until explicitly logged out.

## Shared Preferences
The **Shared Preferences** service is used for storing session tokens, user credentials, and other persistent data. It manages:
- **Login state**: Keeps the user logged in across app sessions.
- **Access Tokens**: Stores the token for API requests.

## Usage
### Verbb Admin App Usage
1. **Login**: Admin logs in using their email and password. The credentials are verified with the backend API.
2. **Home View**: Admins can view a list of schools and add new schools along with teacher details.
3. **Add School**: Opens a bottom sheet where the admin can enter school name, teacher name, and email.

### School Admin App Usage
1. **Login**: Admins log in via Google Sign-In. After successful login, the app verifies if they are registered.
2. **Home View**: If registered, admins are redirected to the home view, where they can see a welcome message.
3. **Not Registered**: If the user is not registered, they are redirected to a page informing them to contact support.
