import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:noteapp/auth/service/auth_service.dart';

import '../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSigningUp = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Create Account',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                // icon: Icons.person,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _emailController,
                label: 'Email',
                // icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                // icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                // icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 32),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSigningUp
                      ? null
                      : () async {
                    if (!_formKey.currentState!.validate()) return;

                    setState(() => _isSigningUp = true);

                    final success = await AuthService().signUpUser(
                      fullName: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );

                    setState(() => _isSigningUp = false);

                    if (success) {
                      Get.offAllNamed(AppRoutes.notes);
                    } else {
                      Get.snackbar('Error', 'User creation failed');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSigningUp
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

        // ✅ Email validation
        if (label == 'Email') {
          final emailRegex =
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

          if (!emailRegex.hasMatch(value.trim())) {
            return 'Please enter a valid email';
          }
        }

        // ✅ Confirm password validation
        if (label == 'Confirm Password' &&
            value != _passwordController.text) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }
}
