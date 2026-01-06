import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noteapp/routes/app_routes.dart';

import 'auth/login_page.dart';
import 'auth/register_page.dart';
import 'connectivity/connectivity.dart';
import 'notes/add_edit_note_page.dart';
import 'notes/notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(ConnectivityController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),

      // ✅ SINGLE SOURCE OF TRUTH
      home: const AuthGate(),

      // Routes only for navigation after login
      getPages: [
        GetPage(name: AppRoutes.login, page: () => const LoginPage()),
        GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
        GetPage(name: AppRoutes.notes, page: () => const NotesPage()),
        GetPage(
          name: AppRoutes.addEditNotePage,
          page: () => const AddEditNotePage(),
        ),
      ],
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return const NotesPage(); // User logged in
        }

        return const LoginPage(); // User logged out
      },
    );
  }
}