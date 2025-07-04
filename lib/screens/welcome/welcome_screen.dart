import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/wave_clipper.dart';
import '../../routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: WaveClipper(),
              child: Container(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: Image.asset(
                      "assets/images/resume_image.png",
                      height: 150,
                      fit: BoxFit.contain,
                      color: Colors.teal.withOpacity(0.8),
                      colorBlendMode: BlendMode.modulate,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Welcome to ResumeXpert",
                    style: GoogleFonts.poppins(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildButton(
                    text: "Login",
                    color: Colors.teal,
                    textColor: Colors.white,
                    icon: LucideIcons.logIn,
                    onPressed: () => Get.toNamed(AppRoutes.login),
                  ),
                  const SizedBox(height: 15),
                  _buildButton(
                    text: "Register",
                    color: Colors.teal.shade700,
                    textColor: Colors.white,
                    icon: LucideIcons.userPlus,
                    onPressed: () => Get.toNamed(AppRoutes.register),
                  ),
                  const SizedBox(height: 15),
                  _buildOutlinedButton(
                    text: "Skip for Now",
                    borderColor: Colors.teal.shade200,
                    textColor: Colors.teal.shade200,
                    icon: LucideIcons.chevronRight,
                    onPressed: () => Get.offNamed(AppRoutes.home),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, size: 22, color: textColor),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String text,
    required Color borderColor,
    required Color textColor,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 2),
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, size: 22, color: textColor),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
