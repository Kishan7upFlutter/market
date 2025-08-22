import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscure;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.obscure = false,
    this.keyboardType,
  });


  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        // Eye icon only if validator is given and obscure is true
        suffixIcon: (widget.validator != null && widget.obscure)
            ? IconButton(
          icon: Image.asset(
            _obscureText
                ? 'assets/eye_off.png' // Closed eye PNG
                : 'assets/eye_on.png',  // Open eye PNG
            height: 20.h,
            width: 20.w,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
    );
  }
}
