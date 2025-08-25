import 'package:flutter/material.dart';
import 'package:market/services/fcm_notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin
{
  bool moved = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  String _token = "Loading...";

  @override
  void initState() {
    super.initState();
    PushNotificationService.initNotifications(context);
    // Token ko UI me dikhane ke liye
    PushNotificationService.getToken().then((value) {
      setState(() {
        _token = value ?? "Token not found";
      });

      print("FCMToken" + " Token : " + value.toString());
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

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
   // await Future.delayed(const Duration(seconds: 5));

   /* final authProv = context.read<AuthProvider>();
    await authProv.loadToken(); // ensure storage se token uth jaye

    final isLoggedIn = authProv.token != null;*/

    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';


    print("Tokenddfdf" + token.toString());

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, token !='' ? '/dashboard' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    final splashProv = context.watch<SplashProvider>();
    final bgHex = splashProv.colors['splashBg'] ?? '#FFFFFF';
    final bg = hexToColor(bgHex);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/splash_background.png"), // PNG ka path
          fit: BoxFit.cover, // Pure screen pe cover karega
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Transparent banaye

        body: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Image.asset(
                "assets/logo.png", // यहाँ अपना logo डालो
                height: 120,
              ),
            ),
          ),
        ),
        //backgroundColor: bg,
        /*body: Stack(
          children: [
            // animated logo center
            //const SizedBox.expand(),
            splashProv.loading==true?Container():AnimatedLogo(moved: moved),
            // loading indicator while config loading
            if (splashProv.loading)
              const Center(child: AppLoader()),
          ],
        ),*/
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
