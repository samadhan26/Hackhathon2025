import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/wave_clipper.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final backgroundColor = Colors.white;
  final textColor = const Color(0xFF2C6975);
  final hintTextColor = const Color(0xFF2C6975).withOpacity(0.6);

  Color get inputFieldColor => const Color(0xFF2C6975);
  Color get buttonColor => const Color(0xFF205072);

  bool isPasswordHidden = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bottomInsetVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true, // 👈 enable keyboard-safe layout
      body: Stack(
        children: [
          // Background wave with conditional bottom wave
          Positioned.fill(
            child: CustomPaint(
              painter: WaveClipper(showBottom: !bottomInsetVisible),
              child: Container(),
            ),
          ),

          // Main content scrollable
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const SizedBox(height: 30),
                  Text(
                    "Welcome Back!",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Login to continue",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: hintTextColor,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email
                  _buildTextField(
                    icon: LucideIcons.mail,
                    hint: "Enter your email",
                    controller: emailCtrl,
                  ),
                  const SizedBox(height: 20),

                  // Password
                  _buildTextField(
                    icon: LucideIcons.lock,
                    hint: "Enter your password",
                    controller: passwordCtrl,
                    isPassword: isPasswordHidden,
                    onSuffixTap: () =>
                        setState(() => isPasswordHidden = !isPasswordHidden),
                  ),
                  const SizedBox(height: 20),

                  _buildButton(
                    text: isLoading ? '' : "Login",
                    color: buttonColor,
                    textColor: Colors.white,
                    onPressed: isLoading ? null : _login,
                    icon: LucideIcons.logIn,
                    showLoading: isLoading,
                  ),

                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.register);
                    }, // Navigate to register
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: textColor,
                        ),
                        children: [
                          TextSpan(
                            text: "Register",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 280),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    VoidCallback? onSuffixTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: hintTextColor, fontSize: 14),
        counterText: '',
        prefixIcon: Icon(icon, color: textColor),
        filled: true,
        fillColor: inputFieldColor.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
    IconData? icon,
    bool showLoading = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null ? color : color.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        elevation: 4,
      ),
      onPressed: onPressed,
      child: showLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 50,
                    child: icon != null
                        ? Icon(icon, color: textColor, size: 20)
                        : null),
                Expanded(
                  child: Center(
                    child: Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
    );
  }

  void _login() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;

    // 🔍 Email validation
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Email and password cannot be empty.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.red,
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      Fluttertoast.showToast(
        msg: "Please enter a valid email address.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters long.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Optionally: Add strong password rules (uppercase, number, etc.)
    final passwordRegex =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$');

    if (!passwordRegex.hasMatch(password)) {
      Fluttertoast.showToast(
        msg:
        "Password must include uppercase, lowercase, number (min 6 chars).",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {

      final response = await http.post(
        Uri.parse("http://192.168.0.22:8000/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Navigate on success
        Get.offNamed(AppRoutes.home);
      } else {
        final errorData = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: errorData['message'] ?? "Invalid credentials",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }


}
