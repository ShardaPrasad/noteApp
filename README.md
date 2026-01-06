NOTE APP (FLUTTER + FIREBASE)

A simple and secure Notes Application built using Flutter, Firebase Authentication,
Cloud Firestore, and GetX. The app supports user authentication, real-time note
management, and internet connectivity handling.

==================================================
FEATURES
==================================================
- Firebase Authentication (Login & Register)
- Auto login using AuthGate
- Create, Edit, Delete Notes
- Real-time Firestore updates
- Connectivity monitoring
- GetX state management and routing
- Material 3 UI

==================================================
PROJECT STRUCTURE
==================================================
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

==================================================
APP FLOW
==================================================
- App launches with AuthGate
- AuthGate listens to Firebase auth state
- If user is logged in -> NotesPage
- If user is logged out -> LoginPage
- User session persists until logout

==================================================
TECH STACK
==================================================
- Flutter
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- GetX
- Material 3

==================================================
SETUP STEPS
==================================================

1. Install Flutter
   https://flutter.dev/docs/get-started/install

2. Clone the repository
   git clone https://github.com/your-username/noteapp.git
   cd noteapp

3. Install dependencies
   flutter pub get

4. Firebase Setup
   - Create a Firebase project
   - Enable Email/Password Authentication
   - Enable Cloud Firestore
   - Add Firebase config files:
     - Android: google-services.json
     - iOS: GoogleService-Info.plist

5. Configure Firebase with FlutterFire
   flutterfire configure

6. Run the app
   flutter run

==================================================
FIREBASE COLLECTIONS
==================================================

users:
- fullName (String)
- email (String)
- createdAt (Timestamp)
- isActive (Boolean)

notes:
- title (String)
- content (String)
- createdAt (Timestamp)
- userId (String)

==================================================
AUTHOR
==================================================
Sharda Prasad
Senior Mobile Developer (Flutter | iOS | SwiftUI)
