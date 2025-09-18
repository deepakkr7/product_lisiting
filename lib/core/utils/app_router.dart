import 'package:flutter/material.dart';
import 'package:product_lisiting/presentation/widgets/custom_nav_bar.dart';

import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/otp_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/register_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/wishlist_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String registration = '/registration';
  static const String home = '/home';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';
  static const String main = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case otp:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OtpPage(
            phoneNumber: args['phoneNumber'],
            isNewUser: args['isNewUser'] ?? false,
            otp: args['otp'], // Pass the OTP
          ),
        );
      case registration:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => RegistrationPage(phoneNumber: phoneNumber),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case wishlist:
        return MaterialPageRoute(builder: (_) => const WishlistPageView());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePageView());
      case main:
        return MaterialPageRoute(builder: (_) => const SmoothNavigation());
      default:
        return MaterialPageRoute(
          builder: (_) =>
          const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}