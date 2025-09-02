import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webappnursingapp/Login/createpassword.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



 // 👈 Make sure this import path is correct

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({Key? key}) : super(key: key);

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool agreedToTerms = false;
  bool isPasswordObscured = true;
  bool isLoading = false;

  String? emailError;
  String? passwordError;
  String? termsError;

  @override
  void initState() {
    super.initState();
    emailController.addListener(validateEmail);
    passwordController.addListener(validatePassword);
  }

  bool get isFormValid {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final emailValid = email.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final passwordValid = password.isNotEmpty && password.length >= 8 && password.length <= 16;

    return emailValid && passwordValid && agreedToTerms;
  }

  void validateEmail() {
    final email = emailController.text.trim();
    setState(() {
      if (email.isEmpty) {

      } else if (email.length < 5 || email.length > 100) {

      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {

      } else {
        emailError = null;
      }
    });
  }

  void validatePassword() {
    final password = passwordController.text;
    setState(() {
      if (password.isEmpty) {

      } else if (password.length < 8 || password.length > 16) {

      } else
      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) {

      } else {
        passwordError = null;
      }
    });
  }
  void loginUser() async {
    setState(() {
      emailError = null;
      passwordError = null;
      termsError = null;
      isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text;

    print('Attempting login with email: $email');

    // Email validation
    if (email.isEmpty ||
        email.length < 5 ||
        email.length > 100 ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      print('Email validation failed');
      setState(() {
        emailError = "Please enter a valid email address";
        isLoading = false;
      });
      return;
    }

    // Password validation (lowercase, uppercase, digit, special char)
    if (password.isEmpty ||
        password.length < 8 ||
        password.length > 16 ||
        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) {
      print('Password validation failed');
      setState(() {
        passwordError = "Password must include lowercase, uppercase, number and special character";
        isLoading = false;
      });
      return;
    }

    // Terms check
    if (!agreedToTerms) {
      print('User has not agreed to terms');
      setState(() {
        termsError = "Please agree to the terms to continue";
        isLoading = false;
      });
      return;
    }

    try {
      print('Sending login request...');

      final Uri url = Uri.http(
        '54.205.191.197:8003',
        '/nursing_app_api/login',
        {
          'email': email,
          'password': password,
        },
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        // No body needed since params are in URL query
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final accessToken = data['access_token'];

        print('Login successful. Token: $accessToken');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('email', email);

        setState(() => isLoading = false);

        showSuccessToast(context, 'You have logged in successfully.', 'Success');

        // Navigate to next screen if needed
        // Navigator.pushNamed(context, '/nextScreen');
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Invalid Email or Password';
        print('Login failed with message: $errorMsg');
        setState(() => isLoading = false);
        showErrorToast(context, errorMsg);
      }
    } catch (e) {
      print('Exception during login: $e');
      setState(() => isLoading = false);
      showErrorToast(context, 'An error occurred. Please try again.');
    }
  }



  void showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          Positioned(
            top: 40,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
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
                          fontWeight: FontWeight.w600,
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
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          TermsConditionsDialog(
            onAgree: () {
              setState(() {
                agreedToTerms = true;
                termsError = null;
              });
              Navigator.of(context).pop();
            },
          ),
    );
  }

  void showSuccessToast(BuildContext context, String message, String code) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          Positioned(
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
                    const Icon(
                        Icons.check_circle, color: Colors.green, size: 32),
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

    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
      context.go('/Voxlipi/create-password');
      // ✅ GoRouter navigation
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
              Positioned(top: -100, left: -80, child: _buildCircle(250)),
              Positioned(top: -20, left: -120, child: _buildCircle(200)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Login', textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B7BC4))),
                        const SizedBox(height: 6),
                        const Text(
                            'Care Begins Here', textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black,
                                fontSize: 14)),
                        const SizedBox(height: 24),

                        const Text(
                            'Email ID', style: TextStyle(fontWeight: FontWeight
                            .w600, fontSize: 12)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: _buildInputField(
                            emailController,
                            'Email',
                            Icons.email_outlined,
                            false,
                            isError: emailError != null,
                          ),
                        ),
                        if (emailError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(emailError!, style: const TextStyle(
                                color: Colors.red, fontSize: 11)),
                          ),

                        const SizedBox(height: 16),
                        const Text(
                            'Password', style: TextStyle(fontWeight: FontWeight
                            .w600, fontSize: 12)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 40,
                          width: 300,
                          child: _buildInputField(
                            passwordController,
                            'Password',
                            Icons.lock_outline,
                            true,
                            isError: passwordError != null,
                          ),
                        ),
                        if (passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(passwordError!, style: const TextStyle(
                                color: Colors.red, fontSize: 11)),
                          ),

                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Checkbox(
                                value: agreedToTerms,
                                onChanged: (val) {
                                  setState(() {
                                    agreedToTerms = val ?? false;
                                    termsError = agreedToTerms ? null : "";
                                  });

                                  if (val == true) {
                                    _showTermsDialog();
                                  }
                                },
                                activeColor: const Color(0xFF1B7BC4),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text.rich(
                                    TextSpan(
                                      style: TextStyle(fontSize: 12),
                                      children: [
                                        TextSpan(
                                            text: 'By continue, you agree to the '),
                                        TextSpan(
                                          text: 'Terms & Conditions',
                                          style: TextStyle(
                                            decoration: TextDecoration
                                                .underline,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy.',
                                          style: TextStyle(
                                            decoration: TextDecoration
                                                .underline,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (termsError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        termsError!,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 11),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),


                        const SizedBox(height: 34),
                        Center(
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: (!isLoading && isFormValid)
                                  ? loginUser
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B7BC4),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                // Optional: dim color when disabled
                                disabledBackgroundColor: Colors.grey.shade400,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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

  Widget _buildCircle(double size) =>
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
      );

  Widget _buildInputField(TextEditingController controller,
      String hint,
      IconData icon,
      bool isPassword, {
        bool isError = false,
      }) {
    final Color fieldColor = const Color(0xFFE3F2FD);

    return TextField(
      controller: controller,
      obscureText: isPassword && isPasswordObscured,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r"\s")), // ❌ disallow spaces
      ],
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: fieldColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            isPasswordObscured ? Icons.visibility_off : Icons.visibility,
            size: 20,
            color: Colors.grey,
          ),
          onPressed: () =>
              setState(() => isPasswordObscured = !isPasswordObscured),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: fieldColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isError ? Colors.red : fieldColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isError ? Colors.red : fieldColor,
            width: 1.5,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 12),
    );
  }
}
  class TermsConditionsDialog extends StatefulWidget {
  final VoidCallback onAgree;

  const TermsConditionsDialog({required this.onAgree, Key? key}) : super(key: key);

  @override
  _TermsConditionsDialogState createState() => _TermsConditionsDialogState();
}

class _TermsConditionsDialogState extends State<TermsConditionsDialog> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button dismiss
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Container(
          width: 600, // Wider for web
          height: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Terms & Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF1B7BC4),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text:
                              'Welcome to Voxlipi, a clinical voice-to-text documentation tool designed to assist healthcare professionals in generating draft clinical notes.\n',
                            ),
                            TextSpan(
                              text: 'By proceeding, you acknowledge and agree to the following:\n',

                            ),
                            const TextSpan(
                              text:
                              'This application uses automated voice recognition technology to convert spoken words into written text. While it is designed to improve documentation efficiency, the transcribed content may contain errors, omissions, or misinterpretations due to variations in speech, background noise, accent, or software limitations.\n'
                                  '',
                            ),

                            TextSpan(
                              text: 'You acknowledge and accept that:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            _bulletPoint(
                                'You are solely responsible for reviewing, editing, and verifying the accuracy, completeness, and appropriateness of any content generated by this application before it is used for clinical, legal, billing, or compliance purposes.'),
                            _bulletPoint(
                                'This app is a documentation aid, not a certified medical device or legal record generator, and does not replace your professional judgment, medical decision-making, or compliance obligations.'),
                            _bulletPoint(
                                'You will ensure that all use of this application is in accordance with federal and state healthcare regulations, as well as your institution’s documentation and privacy policies.'),
                            _bulletPoint(
                                'Voxlipi, its developers, and affiliated entities disclaim all liability for any damages, claims, losses, or regulatory violations arising from the use of unreviewed or inaccurately transcribed data.\n'),
                            const TextSpan(
                              text:
                              'Your use of this application constitutes informed acknowledgment and acceptance of these terms and conditions.',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      /// Checkbox and text
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 0.8, // Adjust scale between 0.6 - 0.9 as needed
                            child: Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF1B7BC4),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "I have read, understood, and agree to the terms above. I acknowledge that I am responsible for reviewing and validating all transcribed content for clinical and regulatory accuracy.",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: isChecked ? widget.onAgree : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B7BC4),
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 34, vertical: 14),
                  ),
                  child: Text(
                    "I Agree",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  WidgetSpan _bulletPoint(String text) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Baseline(
          baseline: 18, // tweak this value as needed
          baselineType: TextBaseline.alphabetic,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Text(
                  '•',
                  style: TextStyle(
                    fontSize: 18, // large bullet
                    color: Colors.black,
                    height: 1.0, // tight control
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
