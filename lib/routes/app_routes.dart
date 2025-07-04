import 'package:get/get.dart';
import 'package:hackathon/screens/home/home_screen.dart';
import 'package:hackathon/screens/onboarding/onboarding_screen.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/chats/chats_screen.dart';
import '../screens/welcome/welcome_screen.dart';

class AppRoutes {
  static const onboarding = '/onboarding';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  static final routes = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: home, page: () => const HomeScreen()),
  ];
}
