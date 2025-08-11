import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final double size;
  const AppLoader({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: size, height: size, child: const CircularProgressIndicator()));
  }
}
