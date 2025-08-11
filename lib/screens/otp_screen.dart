import 'package:flutter/material.dart';
import '../widgets/app_textfield.dart';
import '../widgets/app_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool otpSent = false;

  void sendOtp() {
    if (phoneCtrl.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid mobile')));
      return;
    }
    setState(() => otpSent = true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent (simulated)')));
  }

  void verifyOtp() {
    if (otpCtrl.text.trim() == '1234') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verified (simulated)')));
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP (try 1234)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(children: [
            AppTextField(label: 'Mobile Number', controller: phoneCtrl, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            if (otpSent)
              AppTextField(label: 'Enter OTP', controller: otpCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            if (!otpSent)
              AppButton(text: 'Send OTP', onTap: sendOtp)
            else
              AppButton(text: 'Verify OTP', onTap: verifyOtp),
          ]),
        ),
      ),
    );
  }
}
