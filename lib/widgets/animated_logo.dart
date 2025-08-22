import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedLogo extends StatelessWidget {
  final bool moved;
  final double size;
  const AnimatedLogo({super.key, required this.moved, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      alignment: moved ? Alignment.center : const Alignment(0, 1.3),
      child: Container(
        width: size.h,
        height: size.h,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black,width: 5.w) ,
            borderRadius: BorderRadius.circular(80.r),
            image: const DecorationImage(image: AssetImage('assets/logo.png'), fit: BoxFit.cover),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10.r, offset: const Offset(0,6))]
        ),
      ),
    );
  }
}
