import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webappnursingapp/Login/originallogin.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isNewPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isButtonEnabled = false;

  String? newPasswordError;
  String? confirmPasswordError;

  final Color fieldColor = const Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(validateFields);
    confirmPasswordController.addListener(validateFields);
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }


  void validateFields() {
    final trimmedPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final hasTypedNewPassword = trimmedPassword.isNotEmpty;
    final hasTypedConfirmPassword = confirmPassword.isNotEmpty;

    setState(() {
      // New Password Validation
      newPasswordError = !hasTypedNewPassword
          ? null
          : trimmedPassword.isEmpty
          ? "Password should have a minimum of 8 and a maximum of 16 characters"
          : trimmedPassword.length < 8 || trimmedPassword.length > 16
          ? "Password should have a minimum of 8 and a maximum of 16 characters"
          : !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).+$')
          .hasMatch(trimmedPassword)
          ? "Password must include at least one uppercase letter, one lowercase letter, one special character and one number"
          : null;

      // Confirm Password Validation
      confirmPasswordError = !hasTypedConfirmPassword
          ? null
          : confirmPassword != trimmedPassword
          ? "Passwords do not match"
          : null;

      // ✅ Enable button only if both passwords are filled and valid
      isButtonEnabled = hasTypedNewPassword &&
          hasTypedConfirmPassword &&
          newPasswordError == null &&
          confirmPasswordError == null;
    });
  }

  Future<void> resetPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    if (token.isEmpty) {
      showErrorToast(context, 'You must log in first.');
      return;
    }

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final url = Uri.parse('http://192.168.31.236:8003/nursing_app_api/reset-password');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      print('Reset password response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        showSuccessToast(context, "Password reset successfully!");
        Future.delayed(const Duration(seconds: 1), () {
          context.go('/Voxlipi/Login');
        });
      } else {
        final data = jsonDecode(response.body);
        final errorMsg = data['detail'] ?? 'Failed to reset password.';
        showErrorToast(context, errorMsg);
      }
    } catch (e) {
      print('Error during reset password: $e');
      showErrorToast(context, 'Error resetting password. Try again.');
    }
  }


  void showSuccessToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFCFF5CC),
              borderRadius: BorderRadius.circular(12),
            ),
            width: 320,
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () => overlayEntry.remove());
  }

  void handleSubmit() {
    resetPassword();
  }
  void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCDD2),
              borderRadius: BorderRadius.circular(12),
            ),
            width: 320,
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FB),
      body: Center(
        child: Container(
          width: 1000,
          height: 500,
          decoration: BoxDecoration(
            color: const Color(0xFF1B7BC4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -100,
                left: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                top: -20,
                left: -120,
                child: Container(
                  width: 200,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 500,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/logo1.png',
                      width: 300,
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 450,
                    margin: const EdgeInsets.only(left: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Reset Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B7BC4),
                          ),
                        ),
                        const SizedBox(height: 34),

                        const Text('New Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: newPasswordController,
                                  obscureText: isNewPasswordObscured,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r"\s")), // ❌ disallow spaces
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'New Password',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    prefixIcon: const Icon(Icons.lock_outline, size: 18, color: Colors.grey),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isNewPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isNewPasswordObscured = !isNewPasswordObscured;
                                        });
                                      },
                                    ),
                                    errorText: newPasswordError,
                                    errorStyle: const TextStyle(fontSize: 9, color: Colors.red),
                                    errorMaxLines: 2,
                                    border: OutlineInputBorder(borderSide: BorderSide(color: fieldColor)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: fieldColor)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: fieldColor)),
                                    filled: true,
                                    fillColor: fieldColor,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Increased vertical padding
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),



                        const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 60,
                          child: TextField(
                            controller: confirmPasswordController,
                            obscureText: isConfirmPasswordObscured,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r"\s")), // ❌ disallow spaces
                            ],
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: const TextStyle(fontSize: 12),
                              prefixIcon: const Icon(Icons.lock_outline, size: 18, color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordObscured = !isConfirmPasswordObscured;
                                  });
                                },
                              ),
                              errorText: confirmPasswordError,
                              errorMaxLines: 2,
                              errorStyle: const TextStyle(fontSize: 8, color: Colors.red),
                              border: OutlineInputBorder(borderSide: BorderSide(color: fieldColor)),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: fieldColor)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: fieldColor)),
                              filled: true,
                              fillColor: fieldColor,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 52),
                        Center(
                          child: SizedBox(
                            width: 160,
                            child: ElevatedButton(
                              onPressed: isButtonEnabled ? handleSubmit : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isButtonEnabled ? const Color(0xFF1B7BC4) : Colors.grey,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
