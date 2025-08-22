import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoader extends StatelessWidget {
  final double size;
  const AppLoader({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: size.w, height: size.h, child: const CircularProgressIndicator(color: Colors.black,)));
  }
}
