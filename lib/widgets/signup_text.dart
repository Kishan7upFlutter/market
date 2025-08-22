import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpText extends StatelessWidget {
  final VoidCallback onSignUpTap;

  const SignUpText({super.key, required this.onSignUpTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Don't have an account yet? ",
        style:  TextStyle(color: Colors.black, fontSize: 14.sp),
        children: [
          TextSpan(
            text: "Sign Up",
            style: const TextStyle(
              color: Color(0xFFFFBB00),
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onSignUpTap,
          ),
        ],
      ),
    );
  }
}
