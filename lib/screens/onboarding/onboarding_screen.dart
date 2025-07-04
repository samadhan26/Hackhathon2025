import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../core/theme/wave_clipper.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to ResumeXpert",
      "subtitle": "The smart way to create, search, and manage resumes.",
      "image":  "assets/images/resume_image.png",
    },
    {
      "title": "Upload Documents",
      "subtitle": "Easily upload your existing resumes or certificates in PDF or DOCX format.",
      "image": "assets/images/upload-file.png",
    },
    {
      "title": "AI Resume Builder",
      "subtitle": "Generate tailored resumes in different formats using AI suggestions.",
      "image": "assets/images/ai_image.png",
    },
    {
      "title": "Search and Filter",
      "subtitle": "HRs can search, filter, and rank resumes by skills, experience, or location.",
      "image": "assets/images/search.png",
    },
    {
      "title": "Download in Any Format",
      "subtitle": "PDF, DOCX, or Web view – get your resume in the format you need.",
      "image": "assets/images/download.png",
    },
    {
      "title": "Let’s Get Hired",
      "subtitle": "Sign up and get one step closer to your dream job or perfect candidate!",
      "image": "assets/images/hired.png",
    },
  ];


  void _onNext() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(AppRoutes.welcome);
    }
  }

  Widget _buildPage(Map<String, String> data) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 90),
        Image.asset(
          data['image']!,
          height: 180,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.broken_image,
            size: 80,
            color: Color(0xFF33673B),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                data["title"]!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                data["subtitle"]!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF444444),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? const Color(0xFF205072)
                : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    bool isLast = _currentIndex == onboardingData.length - 1;

    if (!isLast) return const SizedBox.shrink(); // Hide button on other pages

    return InkWell(
      onTap: _onNext,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF205072), // Teal-blue
              Color(0xFF33673B), // Forest green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch_outlined,
              color: Colors.white,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'Get Started',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔷 Background Wave (same as WelcomeScreen)
          Positioned.fill(
            child: CustomPaint(
              painter: WaveClipper(),
              child: Container(),
            ),
          ),

          // 🔷 Main content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (_, index) =>
                        _buildPage(onboardingData[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildDots(),
                      const SizedBox(height: 60),
                      _buildBottomButton(),
                      const SizedBox(height: 60),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
