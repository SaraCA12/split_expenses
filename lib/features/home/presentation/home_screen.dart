import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/main_bottom_nav.dart';
import '../../../app/router.dart';
import '../../auth/presentation/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: Lottie.asset(
                    'assets/lottie/home_user.json',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: const BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
                      child: const Icon(Icons.person_rounded, size: 80, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '¡Hola, ${user?.fullName.split(' ').first ?? 'invitado'}!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _HomeOptionCard(
                        icon: Icons.person_outline_rounded,
                        label: 'Perfil',
                        onTap: () => context.push(AppRoutes.profile),
                      ),
                      _HomeOptionCard(
                        icon: Icons.list_alt_rounded,
                        label: 'Mis listas\nde gastos',
                        onTap: () => context.push(AppRoutes.expenseLists),
                      ),
                      _HomeOptionCard(
                        icon: Icons.add_circle_outline_rounded,
                        label: 'Crear lista',
                        onTap: () => context.push(AppRoutes.createExpenseList),
                      ),
                      _HomeOptionCard(
                        icon: Icons.pie_chart_outline_rounded,
                        label: 'Mis gastos',
                        onTap: () => context.push(AppRoutes.myExpenses),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const MainBottomNav(currentIndex: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeOptionCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}