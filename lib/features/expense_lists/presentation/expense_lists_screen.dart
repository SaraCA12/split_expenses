import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/category_donut_chart.dart';
import '../../../core/widgets/main_bottom_nav.dart';
import '../../../app/router.dart';
import '../../../shared/models/expense_list.dart';
import 'expense_lists_provider.dart';

class ExpenseListsScreen extends ConsumerWidget {
  const ExpenseListsScreen({super.key});

  String _typeLabel(ExpenseListType type) {
    switch (type) {
      case ExpenseListType.viaje: return 'Viaje';
      case ExpenseListType.restaurante: return 'Restaurante';
      case ExpenseListType.mercado: return 'Mercado';
      case ExpenseListType.casa: return 'Casa';
      case ExpenseListType.otro: return 'Otro';
    }
  }

  IconData _typeIcon(ExpenseListType type) {
    switch (type) {
      case ExpenseListType.viaje: return Icons.flight_takeoff_rounded;
      case ExpenseListType.restaurante: return Icons.restaurant_rounded;
      case ExpenseListType.mercado: return Icons.shopping_cart_rounded;
      case ExpenseListType.casa: return Icons.home_rounded;
      case ExpenseListType.otro: return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expenseListsProvider);

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Mis listas de gastos',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Listas creadas', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                      const SizedBox(height: 8),
                                      Text('${state.listCount}',
                                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CategoryDonutChart(
                            title: 'Categorías más frecuentes',
                            total: state.categoryDistribution.values.fold<int>(0, (a, b) => a + b).toDouble(),
                            slices: state.categoryDistribution.entries.toList().asMap().entries.map((entry) {
                              final index = entry.key;
                              final type = entry.value.key;
                              final count = entry.value.value;
                              return DonutSliceData(
                                label: _typeLabel(type),
                                value: count.toDouble(),
                                color: AppColors.chartPalette[index % AppColors.chartPalette.length],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          ...state.lists.map((list) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () => context.push(AppRoutes.expenseListDetailPath(list.id)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48, height: 48,
                                          decoration: const BoxDecoration(color: AppColors.avatarBg2, shape: BoxShape.circle),
                                          child: Icon(_typeIcon(list.type), color: AppColors.primary),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(list.name, style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                              Text('${list.participants.length} participantes', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 100),
                        ],
                      ),
              ),
              const MainBottomNav(currentIndex: 1),
            ],
          ),
        ),
      ),
    );
  }
}