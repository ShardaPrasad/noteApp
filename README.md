NOTE APP (FLUTTER + FIREBASE)

A simple and secure Notes Application built using Flutter, Firebase Authentication,
Cloud Firestore, and GetX. The app supports user authentication, real-time note
management, and internet connectivity handling.

FEATURES
- Firebase Authentication (Login & Register)
- Auto login using AuthGate
- Create, Edit, Delete Notes
- Real-time Firestore updates
- Connectivity monitoring
- GetX state management and routing
- Material 3 UI

PROJECT STRUCTURE
lib/
 auth/
  - login_page.dart
  - register_page.dart
 connectivity/
  - connectivity.dart
 model/
  - app_user.dart
  - note.dart
 notes/
  - add_edit_note_page.dart
  - notecard_page.dart
  - notes_page.dart
 routes/
  - app_routes.dart
 services/
 main.dart

APP FLOW
- App starts with AuthGate
- If user is logged in -> NotesPage
- If user is logged out -> LoginPage

TECH STACK
- Flutter
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- GetX
- Material 3

SETUP
1. Clone repository
2. Run flutter pub get
3. Configure Firebase (Android & iOS)
4. Enable Email/Password Authentication
5. Run flutter run

FIREBASE COLLECTIONS

users:
- fullName
- email
- createdAt
- isActive

notes:
- title
- content
- createdAt
- userId

AUTHOR
Sharda Prasad
Senior Mobile Developer (Flutter | iOS | SwiftUI)
