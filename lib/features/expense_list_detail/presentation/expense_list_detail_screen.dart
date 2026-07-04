import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/main_bottom_nav.dart';
import '../../../app/router.dart';
import 'expense_list_detail_provider.dart';
import 'add_expense_screen.dart';
import 'widgets/participant_balance_sheet.dart';

class ExpenseListDetailScreen extends ConsumerWidget {
  final String listId;
  const ExpenseListDetailScreen({required this.listId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expenseListDetailProvider(listId));

    if (state.isLoading && state.list == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.list == null) {
      return const Scaffold(body: Center(child: Text('Lista no encontrada')));
    }

    final isBalanced = state.totalListBalance == 0;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(AppRoutes.expenseLists);
                            }
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.arrow_back, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(state.list!.name,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total de la lista', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(CurrencyFormatter.format(state.totalAmount),
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                isBalanced ? Icons.check_circle_rounded : Icons.error_rounded,
                                color: isBalanced ? AppColors.positive : AppColors.negative,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isBalanced ? 'Todos están a paz y salvo' : CurrencyFormatter.format(state.totalListBalance),
                                style: TextStyle(
                                  color: isBalanced ? AppColors.positive : AppColors.negative,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => showParticipantBalanceSheet(context, state.balances),
                              icon: const Icon(Icons.people_alt_rounded, size: 18),
                              label: const Text('Ver balance de participantes'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.expenses.isEmpty
                    ? Center(child: Text('Aún no hay gastos registrados', style: TextStyle(color: AppColors.textSecondary)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = state.expenses[index];
                          final payer = state.list!.participants.firstWhere(
                            (p) => p.id == expense.paidById,
                            orElse: () => state.list!.participants.first,
                          );
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(expense.name, style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                      const SizedBox(height: 4),
                                      Text('Pagó ${payer.name}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                Text(CurrencyFormatter.format(expense.amount),
                                    style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              MainBottomNav(
                currentIndex: -1,
                onFabTapOverride: () => showAddExpenseSheet(context, ref, listId, state.list!.participants),
              ),
            ],
          ),
        ),
      ),
    );
  }
}