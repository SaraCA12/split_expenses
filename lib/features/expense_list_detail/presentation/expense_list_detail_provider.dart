import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/expense_list_repository.dart';
import '../domain/balance_calculator.dart';
import '../../../shared/models/expense.dart';
import '../../../shared/models/expense_list.dart';
import '../../../core/utils/id_generator.dart';

final expenseListRepositoryProvider = Provider<ExpenseListRepository>((ref) {
  return ExpenseListRepository();
});

class ExpenseListDetailState {
  final ExpenseList? list;
  final List<Expense> expenses;
  final List<ParticipantBalance> balances;
  final double totalListBalance;
  final bool isLoading;
  final String? errorMessage;

  const ExpenseListDetailState({
    this.list,
    this.expenses = const [],
    this.balances = const [],
    this.totalListBalance = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  double get totalAmount => double.parse(
      expenses.fold<double>(0, (sum, e) => sum + e.amount).toStringAsFixed(2));

  ExpenseListDetailState copyWith({
    ExpenseList? list,
    List<Expense>? expenses,
    List<ParticipantBalance>? balances,
    double? totalListBalance,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ExpenseListDetailState(
      list: list ?? this.list,
      expenses: expenses ?? this.expenses,
      balances: balances ?? this.balances,
      totalListBalance: totalListBalance ?? this.totalListBalance,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ExpenseListDetailNotifier extends StateNotifier<ExpenseListDetailState> {
  ExpenseListDetailNotifier(this._repository, this._listId)
      : super(const ExpenseListDetailState()) {
    _loadInitialData();
  }

  final ExpenseListRepository _repository;
  final String _listId;

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final list = await _repository.getListById(_listId);
      final expenses = await _repository.getExpensesByListId(_listId);
      final balances = BalanceCalculator.calculate(
        participants: list.participants,
        expenses: expenses,
      );

      state = state.copyWith(
        list: list,
        expenses: expenses,
        balances: balances,
        totalListBalance: BalanceCalculator.totalListBalance(balances),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> addExpense({
    required String name,
    required double amount,
    required String paidById,
  }) async {
    if (state.list == null) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final newExpense = Expense(
        id: IdGenerator.generate(),
        listId: _listId,
        name: name.trim(),
        amount: amount,
        paidById: paidById,
        createdAt: DateTime.now(),
      );

      final saved = await _repository.addExpense(newExpense);

      final nuevosGastos = [...state.expenses, saved];
      final nuevosBalances = BalanceCalculator.calculate(
        participants: state.list!.participants,
        expenses: nuevosGastos,
      );

      state = state.copyWith(
        expenses: nuevosGastos,
        balances: nuevosBalances,
        totalListBalance: BalanceCalculator.totalListBalance(nuevosBalances),
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}

final expenseListDetailProvider =
    StateNotifierProvider.family<ExpenseListDetailNotifier, ExpenseListDetailState, String>(
        (ref, listId) {
  final repository = ref.watch(expenseListRepositoryProvider);
  return ExpenseListDetailNotifier(repository, listId);
});