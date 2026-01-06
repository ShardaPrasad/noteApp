📒 Note App (Flutter + Firebase)

A simple and secure Notes Application built using Flutter, Firebase Authentication, Cloud Firestore, and GetX.
The app supports user authentication, real-time note management, and internet connectivity handling.

✨ Features
🔐 Firebase Authentication
Email & Password Login
Registration
Auto session handling using AuthGate

📝 Notes Management
Create, Edit, Delete notes
Real-time updates

🌐 Connectivity Monitoring
Detects internet availability using GetX controller

🚀 State Management & Routing
GetX for navigation and dependency injection

🎨 Material 3 UI

🔁 Auto Login
User stays logged in unless explicitly logged out

📂 Project Structure
lib/
│── auth/
│   ├── login_page.dart
│   ├── register_page.dart
│   └── route_logic/
│
│── connectivity/
│   └── connectivity.dart
│
│── model/
│   ├── app_user.dart
│   └── note.dart
│
│── notes/
│   ├── add_edit_note_page.dart
│   ├── notecard_page.dart
│   └── notes_page.dart
│
│── routes/
│   └── app_routes.dart
│
│── services/
│
│── main.dart

🧠 App Flow (Authentication Logic)
AuthGate listens to FirebaseAuth.instance.authStateChanges()
If user is logged in → navigates to NotesPage
If user is logged out → navigates to LoginPage
This ensures a single source of truth for authentication state

🛠️ Tech Stack
Flutter
Firebase Core
Firebase Authentication
Cloud Firestore
GetX
Material 3
🔧 Setup Instructions

1️⃣ Clone the Repository

git clone https://github.com/your-username/noteapp.git
cd noteapp

2️⃣ Install Dependencies

flutter pub get

3️⃣ Firebase Setup

Create a Firebase project
Enable Email/Password Authentication
Add Firebase configuration files:
google-services.json (Android)
GoogleService-Info.plist (iOS)

Run:
flutterfire configure
4️⃣ Run the App

flutter run

🔐 Firebase Collections

users
{
  "fullName": "User Name",
  "email": "user@email.com",
  "createdAt": "timestamp",
  "isActive": true
}
notes
{
  "title": "Note title",
  "content": "Note content",
  "createdAt": "timestamp",
  "userId": "firebase_uid"
}

🚦 Routing

Routes are managed using GetX:

/login
/register
/notes
/addEditNote

📱 Minimum Requirements

Flutter SDK ≥ 3.x
Android API 21+

iOS 12+

🧑‍💻 Author
Sharda Prasad
Senior Mobile Developer (Flutter | iOS | SwiftUI)
📧 Email: shardaprasad1111@gmail.com
