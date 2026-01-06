
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:noteapp/auth/service/auth_service.dart';
import '../routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign In to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),

                // ✅ Email
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // ✅ Password
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                      if (!_formKey.currentState!.validate()) return;

                      setState(() => _isLoading = true);

                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      final success = await AuthService().loginUser(
                        email: email,
                        password: password,
                      );

                      setState(() => _isLoading = false);

                      if (success) {
                        Get.offAllNamed(AppRoutes.notes);
                      } else {
                        Get.snackbar(
                          '',
                          'User account or password incorrect. Please verify the account.',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.register);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ------------------
  /// Reusable TextField
  /// ------------------
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }

        // Email validation
        if (label == 'Email') {
          final emailRegex =
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

          if (!emailRegex.hasMatch(value.trim())) {
            return 'Please enter a valid email';
          }
        }

        return null;
      },
    );
  }
}


