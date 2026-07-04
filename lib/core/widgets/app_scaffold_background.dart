import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppScaffoldBackground extends StatelessWidget {
  final Widget child;

  const AppScaffoldBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(child: child),
    );
  }
}