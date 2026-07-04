import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/category_donut_chart.dart';
import '../../../core/widgets/main_bottom_nav.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../app/router.dart';
import '../../../shared/models/expense_list.dart';
import 'my_expenses_provider.dart';

class MyExpensesScreen extends ConsumerWidget {
  const MyExpensesScreen({super.key});

  String _typeLabel(ExpenseListType type) {
    switch (type) {
      case ExpenseListType.viaje: return 'Viaje';
      case ExpenseListType.restaurante: return 'Restaurante';
      case ExpenseListType.mercado: return 'Mercado';
      case ExpenseListType.casa: return 'Casa';
      case ExpenseListType.otro: return 'Otro';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myExpensesProvider);

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
                    Text('Mis gastos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    CategoryDonutChart(
                      title: 'Distribución de mis gastos',
                      total: state.totalAmount,
                      slices: state.categoryDistribution.asMap().entries.map((entry) {
                        final index = entry.key;
                        final cat = entry.value;
                        return DonutSliceData(
                          label: _typeLabel(cat.type),
                          value: cat.totalAmount,
                          color: AppColors.chartPalette[index % AppColors.chartPalette.length],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('Gastos relacionados a ti', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    if (state.myExpenses.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: Text('Aún no tienes gastos registrados', style: TextStyle(color: AppColors.textSecondary))),
                      )
                    else
                      ...state.myExpenses.map((expense) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                          child: Row(
                            children: [
                              Expanded(child: Text(expense.name, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                              Text(CurrencyFormatter.format(expense.amount), style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                            ],
                          ),
                        );
                      }),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              const MainBottomNav(currentIndex: 2),
            ],
          ),
        ),
      ),
    );
  }
}