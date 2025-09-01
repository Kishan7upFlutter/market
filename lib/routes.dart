import 'package:flutter/material.dart';
import 'package:market/presentation/screens/bank_list_screen.dart';
import 'package:market/presentation/screens/brach_list_screen.dart';
import 'package:market/presentation/screens/dashboard_screen.dart';
import 'package:market/presentation/screens/login_screen.dart';
import 'package:market/presentation/screens/news_list.dart';
import 'package:market/presentation/screens/notification_list.dart';
import 'package:market/presentation/screens/number_list_screen.dart';
import 'package:market/presentation/screens/otp_screen.dart';
import 'package:market/presentation/screens/pdf_list_screen.dart';
import 'package:market/presentation/screens/sample_api_UI.dart';
import 'package:market/presentation/screens/signup_screen.dart';
import 'package:market/presentation/screens/splash_screen.dart';


final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  //'/': (context) => const SampleApiUi(),
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignupScreen(),
  '/otp': (context) => const OtpScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/newsScreen': (context) => const NewsScreen(),
  '/notificationScreen': (context) => const NotificationScreen(),
  '/branchScreen': (context) => const BrachListScreen(),
  '/bankScreen': (context) => const BankListScreen(),
  '/pdfScreen': (context) => const PdfListScreen(),
  '/numberScreen': (context) => const NumberListScreen(),

  //BankListScreen

};
