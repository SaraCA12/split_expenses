import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../auth/presentation/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app/router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    // Tiempo mínimo para que el Lottie se vea, aunque cargue rápido.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    context.go(isAuthenticated ? AppRoutes.home : AppRoutes.landing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Lottie.asset(
                    'assets/lottie/splash.json',
                    fit: BoxFit.contain,
                    repeat: true,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback mientras no exista el archivo .json real
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 90,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Gastos Compartidos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Divide, calcula, tranquilo',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}