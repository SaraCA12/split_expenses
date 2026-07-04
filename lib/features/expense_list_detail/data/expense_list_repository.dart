import '../../../shared/data/mock_database.dart';
import '../../../shared/models/expense.dart';
import '../../../shared/models/expense_list.dart';

class ExpenseListRepository {
  final _db = MockDatabase.instance;

  Future<ExpenseList> getListById(String listId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = _db.lists.where((l) => l.id == listId).firstOrNull;
    if (list == null) {
      throw Exception('Lista no encontrada: $listId');
    }
    return list;
  }

  Future<List<Expense>> getExpensesByListId(String listId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(
      _db.expenses.where((e) => e.listId == listId),
    );
  }

  Future<Expense> addExpense(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (expense.amount <= 0) {
      throw Exception('El monto debe ser mayor a cero');
    }

    _db.expenses.add(expense);
    return expense;
  }
}