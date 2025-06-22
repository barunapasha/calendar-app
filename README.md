# Flutter Calendar App with Firebase

A feature-rich, modern calendar mobile application built with Flutter and integrated with Firebase for backend services. This app provides real-time event synchronization, user authentication, and a sleek, responsive UI inspired by an elegant design concept.

![App Screenshot](https://i.imgur.com/L12sE0V.png)

---

## ✨ Features

- **Dynamic Calendar View**: An interactive calendar with the ability to switch between months and select specific dates.
- **Event Management**: Create, view, edit, and delete events seamlessly.
- **Real-time Database**: Utilizes **Cloud Firestore** to keep event data synced across all user devices in real-time.
- **User Authentication**: Secure user login and registration functionality powered by **Firebase Authentication**.
- **Data Security**: Firestore rules ensure that users can only access their own data.
- **Clean Architecture**: Built using **BLoC/Cubit** for state management, promoting a scalable and maintainable codebase.
- **Modern UI**: Polished user interface with subtle animations, custom fonts, and a dark theme.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
  - **Database**: Cloud Firestore
  - **Authentication**: Firebase Authentication
- **State Management**: flutter_bloc (Cubit)
- **UI & Components**:
  - `table_calendar` for the main calendar view.
  - `google_fonts` for custom typography.
  - `intl` for date formatting.
- **Architecture**: Feature-first project structure.

---

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.0.0 or higher)
- A code editor like VS Code or Android Studio.
- A Firebase account.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/calender-app.git
    cd calender-app
    ```

2.  **Set up Firebase:**
    - Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
    - Add a Flutter app to your project.
    - Follow the instructions to download and install the Firebase CLI.
    - Run the following commands to connect your local app to your Firebase project:
      ```sh
      firebase login
      flutterfire configure
      ```
    - In the Firebase Console, navigate to **Authentication** > **Sign-in method** and enable the **Email/Password** provider.
    - Navigate to **Cloud Firestore** > **Rules** and paste the following rules to secure your database:
      ```
      rules_version = '2';
      service cloud.firestore {
        match /databases/{database}/documents {
          match /users/{userId}/events/{eventId} {
            allow read, write: if request.auth != null && request.auth.uid == userId;
          }
        }
      }
      ```

3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

4.  **Run the application:**
    ```sh
    flutter run
    ```

---

This project serves as a comprehensive example of a full-stack Flutter application. Feel free to explore, modify, and use it as a foundation for your own projects.
