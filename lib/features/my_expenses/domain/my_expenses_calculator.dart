import '../../../shared/models/expense.dart';
import '../../../shared/models/expense_list.dart';

class CategoryAmount {
  final ExpenseListType type;
  final double totalAmount;

  const CategoryAmount({
    required this.type,
    required this.totalAmount,
  });
}

class MyExpensesCalculator {
  /// Filtra los gastos donde el usuario participó (es parte de alguna lista
  /// que contenga ese gasto) y sirve tanto para el total como para el anillo.
  static List<Expense> filterByUserParticipation({
    required List<ExpenseList> allLists,
    required List<Expense> allExpenses,
    required String userParticipantId,
  }) {
    final listIdsDelUsuario = allLists
        .where((l) => l.participants.any((p) => p.id == userParticipantId))
        .map((l) => l.id)
        .toSet();

    return allExpenses.where((e) => listIdsDelUsuario.contains(e.listId)).toList();
  }

  /// Agrupa el monto total de gastos por tipo de lista (viaje, mercado, etc.)
  static List<CategoryAmount> groupByListType({
    required List<ExpenseList> allLists,
    required List<Expense> userExpenses,
  }) {
    final Map<String, ExpenseListType> listTypeById = {
      for (final l in allLists) l.id: l.type,
    };

    final Map<ExpenseListType, double> totals = {};
    for (final expense in userExpenses) {
      final type = listTypeById[expense.listId];
      if (type == null) continue;
      totals[type] = (totals[type] ?? 0) + expense.amount;
    }

    return totals.entries
        .map((e) => CategoryAmount(
              type: e.key,
              totalAmount: double.parse(e.value.toStringAsFixed(2)),
            ))
        .toList();
  }

  static double totalAmount(List<Expense> expenses) {
    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    return double.parse(total.toStringAsFixed(2));
  }
}