import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'floating_bottom_nav.dart';
import '../../app/router.dart';

/// currentIndex: 0=Home, 1=Mis Listas, 2=Mis Gastos, 3=Perfil, -1=ninguno activo (ej. detalle de lista)
class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onFabTapOverride;

  const MainBottomNav({
    required this.currentIndex,
    this.onFabTapOverride,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingBottomNav(
      currentIndex: currentIndex,
      items: const [
        NavItemData(icon: Icons.home_rounded, route: AppRoutes.home),
        NavItemData(icon: Icons.list_alt_rounded, route: AppRoutes.expenseLists),
        NavItemData(icon: Icons.pie_chart_rounded, route: AppRoutes.myExpenses),
        NavItemData(icon: Icons.person_rounded, route: AppRoutes.profile),
      ],
      onFabTap: onFabTapOverride ?? () => context.push(AppRoutes.createExpenseList),
      onItemTap: (index) {
        const routes = [
          AppRoutes.home,
          AppRoutes.expenseLists,
          AppRoutes.myExpenses,
          AppRoutes.profile,
        ];
        if (index != currentIndex) context.go(routes[index]);
      },
    );
  }
}