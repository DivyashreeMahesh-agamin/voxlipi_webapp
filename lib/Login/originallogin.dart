import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:webappnursingapp/Billing/Ready%20to%20Bill%20Encounter%20List.dart';
import 'package:webappnursingapp/Login/resetpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LoginPage1 extends StatefulWidget {
  const LoginPage1({Key? key}) : super(key: key);

  @override
  State<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordObscured = true;
  bool rememberMe = false;
  bool isButtonEnabled = false;

  String? emailError;
  String? passwordError;
  String? rememberMeError;

  final Color fieldColor = const Color(0xFFE3F2FD);
  void loadStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email') ?? '';

    setState(() {
      emailController.text = savedEmail;
    });
  }


  @override
  void initState() {
    super.initState();
    loadStoredCredentials(); // ⬅️ Load saved email
    emailController.addListener(validateFields);
    passwordController.addListener(validateFields);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateFields();
    });
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void sendForgotPasswordRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final email = emailController.text.trim();
    if (email.isEmpty) {
      showErrorToast(context, "Please enter your email");
      return;
    }

    print('Sending forgot password request with token: $token');

    final Uri url = Uri.parse('http://192.168.31.236:8003/nursing_app_api/api/v1/forgot-password');

    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'email': email}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final msg = data['message'] ?? 'Reset password link sent successfully.';
        showSuccessToast(context, msg, '');
      } else {
        try {
          final data = jsonDecode(response.body);
          final errorMsg = data['message'] ?? 'Failed to send reset password link.';
          showErrorToast(context, errorMsg);
        } catch (_) {
          showErrorToast(context, 'Unexpected error occurred.');
        }
      }
    } catch (e) {
      print('Error sending forgot password request: $e');
      showErrorToast(context, 'Error sending request. Please try again.');
    }
  }


  void validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError = "Email cannot be empty";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      emailError = "Invalid email format";
    } else {
      emailError = null;
    }
  }

  void validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError = "";
    } else if (password.length < 8 || password.length > 16) {
      passwordError = "";
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      passwordError = "";
    } else {
      passwordError = null;
    }
  }

  void validateRememberMe() {
    if (!rememberMe) {
      rememberMeError = "";
    } else {
      rememberMeError = null;
    }
  }

  void validateFields() {
    final password = passwordController.text;

    validateEmail();
    validatePassword();
    validateRememberMe();

    setState(() {
      isButtonEnabled = emailError == null &&
          passwordError == null &&
          rememberMe &&
          password.isNotEmpty;
    });
  }

  void validateAndLogin() {
    validateFields();
    if (emailError == null && passwordError == null && rememberMe) {
      showSuccessToast(context, 'You have logged in successfully.', 'N/A');
      context.go('/Voxlipi/Onboarding');

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B7BC4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          const SizedBox(height: 24),

                          const Text('Email ID', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                          const SizedBox(height: 6),
                          IgnorePointer(
                            child: TextField(
                              controller: emailController,
                              readOnly: true, // Keeps it non-editable
                              mouseCursor: SystemMouseCursors.basic, // Ensures arrow cursor
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                              decoration: buildInputDecoration(
                                hintText: 'Email',
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey, size: 18),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: isPasswordObscured,
                              cursorColor: Colors.black,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"\s")), // ❌ disallow spaces
                              ],
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: const TextStyle(fontSize: 12),
                                filled: true,
                                fillColor: fieldColor,
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                errorText: passwordError,
                                errorStyle: const TextStyle(fontSize: 10, color: Colors.red),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: fieldColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: fieldColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: fieldColor, width: 2),
                                ),
                                // Keep border same even in error state
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: fieldColor),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: fieldColor, width: 2),
                                ),
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 18),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordObscured = !isPasswordObscured;
                                    });
                                  },
                                ),
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),

                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: sendForgotPasswordRequest,
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(fontSize: 12, color: Color(0xFF1B7BC4)),
                                    ),
                                  ),
                                ),
                              ),



                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Checkbox(
                                      value: rememberMe,
                                      activeColor: const Color(0xFF1B7BC4),
                                      onChanged: (value) {
                                        setState(() {
                                          rememberMe = value ?? false;
                                        });
                                        validateFields();
                                      },
                                    ),
                                  ),
                                  const Text('Remember Me', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              if (rememberMeError != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    rememberMeError!,
                                    style: const TextStyle(fontSize: 10, color: Colors.red),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: isButtonEnabled ? validateAndLogin : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isButtonEnabled ? const Color(0xFF1B7BC4) : Colors.grey,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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
              color: const Color(0xFFFFCDD2), // light red background
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

}
