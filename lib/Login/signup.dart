import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:webappnursingapp/Login/Login.dart';

class WebSignUpPage extends StatefulWidget {
  const WebSignUpPage({super.key});

  @override
  State<WebSignUpPage> createState() => _WebSignUpPageState();
}

class _WebSignUpPageState extends State<WebSignUpPage> {


  final TextEditingController emailController = TextEditingController(text: 'user@example.com');
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController facilityController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController medicalGroupController = TextEditingController();

  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isLoading = false;

  String? firstNameError;
  String? lastNameError;
  String? facilityError;
  String? newPasswordError;
  String? confirmPasswordError;

  bool get isFormValid {
    return firstNameError == null &&
        lastNameError == null &&
        facilityError == null &&
        newPasswordError == null &&
        confirmPasswordError == null &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        facilityController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }
  bool get isSignupEnabled {
    return newPasswordError == null && confirmPasswordError == null
        && newPasswordController.text.isNotEmpty
        && confirmPasswordController.text.isNotEmpty;
  }

  Future<void> handleSignUpPressed() async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String newPassword = newPasswordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();
    final String medicalGroup = facilityController.text.trim();




    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://54.205.191.197:8003/nursing_app_api/admin/system-users');

    final Map<String, String> payload = {
      'first_name': firstName,
      'last_name': lastName,
      'medical_group': medicalGroup,
      'new_password': newPassword,
      'confirm_new_password': confirmPassword,
    };

    try {
      final response = await http.post(
        url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },

          body: json.encode(payload),
      );

      final responseJson = json.decode(response.body);
      print('Response JSON: $responseJson');

      if (response.statusCode == 201) {
        final successMessage = responseJson['message'] ?? 'System user created successfully';
        final userId = responseJson['data']?['user_id'] ?? '';
        final orgEmail = responseJson['data']?['organization_email'] ?? '';
        String toastMessage = successMessage;
        if (userId.isNotEmpty) {
          toastMessage += '\nUser ID: $userId';
        }
        if (orgEmail.isNotEmpty) {
          toastMessage += '\nEmail: $orgEmail';
        }
        showSuccessToast(context, toastMessage, 'Success');
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/Voxlipi/login');
          // or if you use go_router:
          // context.go('/yourNewPageRoute');
        });
      } else {
        final errorMessage = responseJson['message'] ?? 'Registration failed';
        showErrorToast(context, errorMessage);
      }
    } catch (e) {
      showErrorToast(context, 'Registration failed: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              color: const Color(0xFFFFE0E0),
              borderRadius: BorderRadius.circular(12),
            ),
            width: 320,
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
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
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60, bottom: 40),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B7BC4),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Positioned(
                    top: -100,
                    right: -80,
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
                    right: -120,
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
                      Expanded(
                        child: Container(
                          height: screenHeight * 0.78,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Sign Up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1B7BC4),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Welcome! Let’s get you set up with a new account.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),

                                  _labelWithStar("First Name"),
                                  _buildTextField(
                                    controller: firstNameController,
                                    hintText: 'First Name',
                                    errorText: firstNameError,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z '-]")),
                                      SingleSpaceInputFormatter(),
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        if (val.isNotEmpty && (val.length < 3 || val.length > 70)) {
                                          firstNameError = 'First name should have a minimum of 3 and a maximum of 70 characters';
                                        } else {
                                          firstNameError = null;
                                        }


                                      });
                                    },
                                  ),

                                  _labelWithStar("Last Name"),
                                  _buildTextField(
                                    controller: lastNameController,
                                    hintText: 'Last Name',
                                    errorText: lastNameError,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z '-]")),
                                      SingleSpaceInputFormatter(),
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        lastNameError = val.length > 70
                                            ? 'Last name should have a maximum of 70 characters'
                                            : null;
                                      });
                                    },
                                  ),
                                  _labelWithStar("Medical Group"),
                                  _buildTextField(
                                    controller: facilityController,
                                    hintText: 'Medical Group',
                                    errorText: facilityError,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z '-]")),
                                      SingleSpaceInputFormatter(),
                                    ],
                                    onChanged: (val) {
                                      final trimmed = val.trim();
                                      setState(() {
                                        if (trimmed.length > 70) {
                                          facilityError = 'Medical Group should have a maximum of 70 characters';
                                        } else if (trimmed.contains(' ')) {
                                          facilityError = 'Spaces are not allowed';
                                        } else {
                                          facilityError = null;
                                        }


                                      });
                                    },
                                  ),
                                  _labelWithStar("New Password"),
                                  _buildTextField(
                                    controller: newPasswordController,
                                    hintText: 'New Password',
                                    obscure: isPasswordObscured,
                                    toggleObscure: () => setState(() => isPasswordObscured = !isPasswordObscured),
                                    errorText: newPasswordError,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r"[^\n]")),
                                      SingleSpaceInputFormatter(),
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        // Validate new password length and format
                                        if (val.isEmpty) {
                                          newPasswordError = null;
                                        } else if (val.length < 8 || val.length > 16) {
                                          newPasswordError = 'Password should have a minimum of 8 and a maximum of 16 characters';
                                        } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,16}$').hasMatch(val)) {
                                          newPasswordError = 'Password must include at least one uppercase letter, one lowercase letter, one special character and one number';
                                        } else {
                                          newPasswordError = null;
                                        }

                                        // Also validate confirm password in case new password changed
                                        final confirmVal = confirmPasswordController.text;
                                        if (confirmVal.isEmpty) {
                                          confirmPasswordError = null;
                                        } else if (confirmVal != val) {
                                          confirmPasswordError = 'Passwords do not match';
                                        } else {
                                          confirmPasswordError = null;
                                        }
                                      });
                                    },
                                  ),

                                  _labelWithStar("Confirm Password"),
                                  _buildTextField(
                                    controller: confirmPasswordController,
                                    hintText: 'Confirm Password',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r"[^\n]")),

                                      SingleSpaceInputFormatter(),
                                    ],
                                    obscure: isConfirmPasswordObscured,
                                    toggleObscure: () => setState(() => isConfirmPasswordObscured = !isConfirmPasswordObscured),
                                    errorText: confirmPasswordError,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val.isEmpty) {
                                          confirmPasswordError = null;  // no error if empty
                                        } else if (val != newPasswordController.text) {
                                          confirmPasswordError = 'Passwords do not match';
                                        } else {
                                          confirmPasswordError = null;
                                        }
                                      });
                                    },

                                  ),
                                  const SizedBox(height: 5),
                                  Center(
                                    child: SizedBox(
                                      height: 36,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: (!isFormValid || isLoading) ? null : handleSignUpPressed,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF1B7BC4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: isLoading
                                            ? const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        )
                                            : const Text(
                                          'Sign Up',
                                          style: TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            'assets/logo1.png',
                            width: 240,
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
      ),
    );
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WebLoginPage()),
      );
    });
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? errorText,
    bool readOnly = false,
    bool obscure = false,
    VoidCallback? toggleObscure,
    ValueChanged<String>? onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscure,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: 12,
          color: readOnly ? Colors.grey.shade600 : Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          errorText: errorText,
          errorStyle: TextStyle(
            fontSize: 9, // change to your desired size
           // optional: set the error text color
          ),
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          filled: true,
          fillColor: readOnly ? const Color(0xFFF0F0F0) : const Color(0xFFE3F2FD),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(6),
          ),
          suffixIcon: toggleObscure != null
              ? IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              size: 18,
              color: Colors.grey,
            ),
            onPressed: toggleObscure,
          )
              : null,
        ),
      ),
    );
  }

  Widget _labelWithStar(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
class SingleSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Replace multiple spaces with a single space
    String newText = newValue.text.replaceAll(RegExp(r'\s+'), ' ');

    // Prevent space at start
    if (newText.startsWith(' ')) {
      newText = newText.trimLeft();
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
