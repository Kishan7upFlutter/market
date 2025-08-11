import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_textfield.dart';
import '../widgets/app_button.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.signIn(emailCtrl.text.trim(), passCtrl.text.trim());
    if (ok) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      if (!mounted) return;
      final err = auth.error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _onBiometric() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.authenticateWithBiometrics();
    if (ok) {
      // Here we assume biometric user has valid token in storage
      if (auth.token != null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No saved session. Please login manually.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometric failed or not available')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Form(
            key: _form,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // profile pic
                 // const CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/profile.png')),
                  const SizedBox(height: 12),
                  AppTextField(label: 'Email', controller: emailCtrl, validator: Validators.validateEmail, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  AppTextField(label: 'Password', controller: passCtrl, validator: Validators.validatePassword, obscure: true),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () => Navigator.pushNamed(context, '/otp'), child: const Text('Forgot? OTP')),
                      if (auth.biometricEnabled)
                        IconButton(onPressed: _onBiometric, icon: const Icon(Icons.fingerprint))
                    ],
                  ),
                  const SizedBox(height: 8),
                  AppButton(text: 'Sign In', onTap: _onLogin, loading: auth.loading),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const SizedBox(width: double.infinity, child: Center(child: Text('Sign Up'))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
