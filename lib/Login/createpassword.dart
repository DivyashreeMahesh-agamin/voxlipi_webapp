import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({Key? key}) : super(key: key);

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? newPasswordError;
  String? confirmPasswordError;
  String? emailError;
  bool isNewPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool hasTypedNewPassword = false;
  bool isFormValid = false;

  final Color fieldColor = const Color(0xFFE3F2FD);
  String token = '';

  @override
  void initState() {
    super.initState();
    loadStoredCredentials();

    // Add listeners to password fields (moved here)
    newPasswordController.addListener(() {
      if (!hasTypedNewPassword && newPasswordController.text.isNotEmpty) {
        hasTypedNewPassword = true;
      }
      validateForm();
    });

    confirmPasswordController.addListener(validateForm);
  }

  void loadStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('access_token') ?? '';
    final savedEmail = prefs.getString('email') ?? '';

    print("Loaded token: $savedToken");

    setState(() {
      token = savedToken;  // `token` here is a state variable, not local
      emailController.text = savedEmail;
    });
  }




  void validateForm() {
    final email = emailController.text.trim();
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    final trimmedPassword = newPassword.trim();

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    final passwordPattern = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).+$');
    final hasInvalidChars = RegExp(r'[<>{}\[\]\\/]').hasMatch(trimmedPassword);

    setState(() {
      // Email validation
      emailError = email.isEmpty
          ? "Email is required"
          : !emailRegex.hasMatch(email)
          ? "Enter a valid email address"
          : null;

      // New Password validation
      newPasswordError = !hasTypedNewPassword
          ? null
          : trimmedPassword.isEmpty
          ? "Password should have a minimum of 8 and a maximum of 16 characters"
          : trimmedPassword.length < 8 || trimmedPassword.length > 16
          ? "Password should have a minimum of 8 and a maximum of 16 characters"
          : trimmedPassword.contains(' ')
          ? "Password cannot contain spaces"
          : hasInvalidChars
          ? "Password contains invalid characters"
          : !passwordPattern.hasMatch(trimmedPassword)
          ? "Password must include at least one uppercase letter, one lowercase letter, one special character and one number"
          : null;

      // Confirm Password validation
      confirmPasswordError = confirmPassword.isEmpty
          ? null
          : confirmPassword != newPassword
          ? "Passwords do not match"
          : null;

      // Form validity
      isFormValid = newPasswordError == null &&
          confirmPasswordError == null &&
          emailError == null &&
          trimmedPassword.isNotEmpty &&
          confirmPassword.isNotEmpty;
      print("===== Form Validation Debug =====");
      print("Email: '${emailController.text.trim()}'");
      print("Email Error: $emailError");

      print("New Password: '${newPasswordController.text}'");
      print("Trimmed Password: '${trimmedPassword}'");
      print("New Password Error: $newPasswordError");

      print("Confirm Password: '${confirmPasswordController.text}'");
      print("Confirm Password Error: $confirmPasswordError");

      print("Final isFormValid: $isFormValid");
      print("==================================");

    });
  }

  Future<void> submit() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Basic validation
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      showErrorToast(context, 'Please fill all fields');
      return;
    }
    if (newPassword != confirmPassword) {
      showErrorToast(context, 'Passwords do not match');
      return;
    }

    print('Token sent: $token');

    try {
      final response = await http.post(
        Uri.parse('http://54.205.191.197:8003/nursing_app_api/api/v1/create-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "new_password": newPassword,
          "confirm_new_password": confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        showSuccessToast(context, data['message'] ?? 'Password Created Successfully.', 'N/A');

        // Redirect to login after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          context.go('/Voxlipi/Login');
        });
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        final data = jsonDecode(response.body);
        showErrorToast(context, data['message'] ?? 'Failed to create password');
      }
    } catch (e) {
      showErrorToast(context, 'Error: $e');
    }
  }



  void showSuccessToast(BuildContext context, String message, String code) {
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
                      fontSize: 14,
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
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
      context.go('/Voxlipi/Login');
    });
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
                      fontSize: 14,
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

  InputDecoration buildInputDecoration({
    required String hintText,
    required Icon prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 12),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      errorMaxLines: 2,
      errorStyle: const TextStyle(fontSize: 9, color: Colors.red),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: errorText != null ? Colors.red : fieldColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorText != null ? Colors.red : fieldColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorText != null ? Colors.red : fieldColor),
      ),
      filled: true,
      fillColor: fieldColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
    );
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
              Positioned(top: -100, left: -80, child: _decorativeCircle(250)),
              Positioned(top: -20, left: -120, child: _decorativeCircle(200)),
              Row(
                children: [
                  Container(
                    width: 500,
                    alignment: Alignment.center,
                    child: Image.asset('assets/logo1.png', width: 300),
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
                          'Create Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF1B7BC4)),
                        ),
                        const SizedBox(height: 20),
                        const Text('Email ID', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 12, color: Colors.black),
                          decoration: buildInputDecoration(
                            hintText: 'Enter Email',
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey, size: 18),
                            errorText: emailError,
                          ),
                        ),



                        const SizedBox(height: 12),
                        const Text('New Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: newPasswordController,
                          obscureText: isNewPasswordObscured,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r"\s")), // ❌ disallow spaces
                          ],
                          style: const TextStyle(fontSize: 12),
                          decoration: buildInputDecoration(
                            hintText: 'New Password',
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isNewPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  isNewPasswordObscured = !isNewPasswordObscured;
                                });
                              },
                            ),
                            errorText: newPasswordError,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: isConfirmPasswordObscured,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r"\s")), // ❌ disallow spaces
                          ],
                          style: const TextStyle(fontSize: 12),
                          decoration: buildInputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordObscured = !isConfirmPasswordObscured;
                                });
                              },
                            ),
                            errorText: confirmPasswordError,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: 160,
                            child: ElevatedButton(
                              onPressed: isFormValid ? submit : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B7BC4),
                                disabledBackgroundColor: Colors.grey,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Create Password',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        )
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

  Widget _decorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }
}
