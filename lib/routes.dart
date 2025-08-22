import 'package:flutter/material.dart';
import 'package:market/screens/news_list.dart';
import 'package:market/screens/notification_list.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/dashboard_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignupScreen(),
  '/otp': (context) => const OtpScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/newsScreen': (context) => const NewsScreen(),
  '/notificationScreen': (context) => const NotificationScreen(),

};
