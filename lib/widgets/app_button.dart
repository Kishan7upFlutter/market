import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool loading;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final btn = ElevatedButton(
      onPressed: loading ? null : onTap,
      style: ElevatedButton.styleFrom(
        minimumSize:  Size(double.infinity, 48.h),
        backgroundColor: const Color(0xFFFFBB00), // #FFBB00 background
        foregroundColor: Colors.white, // text/icon ka color white
      ),
      child: loading
          ? SizedBox(
        height: 20.h,
        width: 20.h,
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          color: Colors.white,
        ),
      )
          : Text(
        text,
        style: const TextStyle(color: Colors.white), // text white
      ),
    );
    return btn;
  }
}
