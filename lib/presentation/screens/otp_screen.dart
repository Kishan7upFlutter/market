import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets/app_button.dart';
import 'package:market/widgets/app_textfield.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid email')));
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
    return SafeArea(
      child: Scaffold(
       // appBar: AppBar(title: const Text('OTP Verification')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: Column(children: [

              const SizedBox(height: 12),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Forgot Password",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.sp))),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("We will reset your password via your email",
                    style: TextStyle(color: Color(0xFF929497),fontWeight: FontWeight.bold,fontSize: 16.sp)),
              ),
//We will reset your password via your email

              const SizedBox(height: 24),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.sp))),
              const SizedBox(height: 5),

              AppTextField(label: 'example@mail.com', controller: phoneCtrl, keyboardType: TextInputType.text),
              const SizedBox(height: 12),
              if (otpSent)
                AppTextField(label: 'Enter OTP', controller: otpCtrl, keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              if (!otpSent)
                AppButton(text: 'Send', onTap: sendOtp)
              else
                AppButton(text: 'Verify OTP', onTap: verifyOtp),
            ]),
          ),
        ),
      ),
    );
  }
}


//dart run change_app_package_name:main com.example.market