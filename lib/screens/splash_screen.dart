import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/splash_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/animated_logo.dart';
import '../widgets/app_loader.dart';
import '../utils/color_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool moved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFlow();
    });
  }

  Future<void> _startFlow() async {
    final splashProv = context.read<SplashProvider>();
    await splashProv.loadConfig();

    // apply theme colors
    final colors = splashProv.colors;
    if (colors.isNotEmpty) {
      context.read<ThemeProvider>().updateFromColorMap(colors);
    }

    // start logo animation
    if (mounted) setState(() => moved = true);
    await Future.delayed(const Duration(milliseconds: 900)); // let animation finish
    // wait additional 5 seconds (as per requirement)
    await Future.delayed(const Duration(seconds: 5));

    final authProv = context.read<AuthProvider>();
    final isLoggedIn = authProv.token != null;

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, isLoggedIn ? '/dashboard' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    final splashProv = context.watch<SplashProvider>();
    final bgHex = splashProv.colors['splashBg'] ?? '#FFFFFF';
    final bg = hexToColor(bgHex);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // animated logo center
          const SizedBox.expand(),
          AnimatedLogo(moved: moved),
          // loading indicator while config loading
          if (splashProv.loading)
            const Center(child: AppLoader()),
        ],
      ),
    );
  }
}
