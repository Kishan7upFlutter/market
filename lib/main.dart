import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'providers/theme_provider.dart';
import 'providers/splash_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Custom App',
          theme: themeProv.themeData,
          initialRoute: '/',
          routes: appRoutes,
        );
      },
    );
  }
}
