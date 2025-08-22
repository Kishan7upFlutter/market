import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/utils/color_utils.dart';
import 'package:market/widgets/signup_text.dart';
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
  final mobileNoCtrl = TextEditingController();

  @override
  void dispose() {
    mobileNoCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.signIn(mobileNoCtrl.text.trim());

    if (ok) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      if (!mounted) return;
      final err = auth.error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));

      if(err=="User Not Found")
        {
          Navigator.pushNamed(context, '/signup');
        }


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
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _form,
            child: Container(
              padding:  EdgeInsets.all(18),
              //decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
              width: double.infinity,
              constraints:  BoxConstraints(maxWidth: 420.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // profile pic
                 // const CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/profile.png')),

                  Text("Welcome to",style: TextStyle(color: Color(0xFF929497),fontSize: 16.sp)),
                   SizedBox(height: 12.h),

                   Image.asset("assets/my_work_space.png"),
                   SizedBox(height: 24.h),

                  Text("Before ordering, please login with your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp,color: Color(
                      0xFF414042))),
                   SizedBox(height: 12.h),

                  Container(
                    height: 124.h,
                    width: 124.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // poora gol
                      border: Border.all(
                        color: Color(0xFF000000), // black border
                        width: 3.w, // border ki motai
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.cover, // image ko circle ke andar fit karega
                      ),
                    ),
                  ),
//Before ordering, please login with your account
                  //FFBB00

                  SizedBox(height: 28.h),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Mobile No.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                   SizedBox(height: 5.h),

                  AppTextField(label: 'Enter Mobile No.', controller: mobileNoCtrl, validator: Validators.maxdigit, keyboardType: TextInputType.number),
                   SizedBox(height: 16.h),



                  SizedBox(height: 5.h),

                  AppButton(text: 'Login', onTap: _onLogin, loading: auth.loading),
                /*  auth.biometricEnabled?Container(
                      margin: EdgeInsets.only(top: 24),
                      child: IconButton(onPressed: _onBiometric, icon:  Icon(Icons.fingerprint,size: 42.sp,))):Container(),
                   SizedBox(height: 24.h),*/


                  /*SignUpText(
                    onSignUpTap: () {
                      print("Sign Up clicked!");
                      Navigator.pushNamed(context, '/signup');
                      // Yaha tum navigation ya koi action laga sakte ho
                    },
                  ),*/

                  //Forgot Password?
                 /* OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const SizedBox(width: double.infinity, child: Center(child: Text('Sign Up'))),
                  )*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
