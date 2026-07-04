import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/my_expenses_calculator.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../expense_lists/presentation/expense_lists_provider.dart';
import '../../expense_list_detail/presentation/expense_list_detail_provider.dart';
import '../../../shared/models/expense.dart';

class MyExpensesState {
  final List<Expense> myExpenses;
  final List<CategoryAmount> categoryDistribution;
  final double totalAmount;

  const MyExpensesState({
    this.myExpenses = const [],
    this.categoryDistribution = const [],
    this.totalAmount = 0,
  });
}

/// Provider derivado (no StateNotifier): se recalcula automáticamente
/// cada vez que cambian las listas o los gastos, sin lógica manual de refresh.
final myExpensesProvider = Provider<MyExpensesState>((ref) {
  final authState = ref.watch(authProvider);
  final listsState = ref.watch(expenseListsProvider);

  final userId = authState.user?.id;
  if (userId == null) return const MyExpensesState();

  // Nota: el usuario logueado (AppUser) y el "participante" dentro de una
  // lista (Participant) son conceptos distintos en el modelo actual —
  // ver nota abajo sobre cómo los vamos a enlazar.
  final userParticipantId = userId;

  // Recolecta TODOS los gastos de TODAS las listas del usuario.
  final allExpenses = <Expense>[];
  for (final list in listsState.lists) {
    final detailState = ref.watch(expenseListDetailProvider(list.id));
    allExpenses.addAll(detailState.expenses);
  }

  final misGastos = MyExpensesCalculator.filterByUserParticipation(
    allLists: listsState.lists,
    allExpenses: allExpenses,
    userParticipantId: userParticipantId,
  );

  final distribucion = MyExpensesCalculator.groupByListType(
    allLists: listsState.lists,
    userExpenses: misGastos,
  );

  return MyExpensesState(
    myExpenses: misGastos,
    categoryDistribution: distribucion,
    totalAmount: MyExpensesCalculator.totalAmount(misGastos),
  );
});