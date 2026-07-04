import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/expense_lists_repository.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../../shared/models/expense_list.dart';

final expenseListsRepositoryProvider = Provider<ExpenseListsRepository>((ref) {
  return ExpenseListsRepository();
});

class ExpenseListsState {
  final List<ExpenseList> lists;
  final Map<ExpenseListType, int> categoryDistribution;
  final bool isLoading;
  final String? errorMessage;

  const ExpenseListsState({
    this.lists = const [],
    this.categoryDistribution = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  int get listCount => lists.length;

  ExpenseListsState copyWith({
    List<ExpenseList>? lists,
    Map<ExpenseListType, int>? categoryDistribution,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ExpenseListsState(
      lists: lists ?? this.lists,
      categoryDistribution: categoryDistribution ?? this.categoryDistribution,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ExpenseListsNotifier extends StateNotifier<ExpenseListsState> {
  ExpenseListsNotifier(this._repository, this._userId, this._ref)
      : super(const ExpenseListsState()) {
    loadLists();
  }

  final ExpenseListsRepository _repository;
  final String _userId;
  final Ref _ref;

  Future<void> loadLists() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final lists = await _repository.getMyLists(_userId);
      final distribution = await _repository.getCategoryDistribution(_userId);

      state = state.copyWith(
        lists: lists,
        categoryDistribution: distribution,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> createList({
    required String name,
    required String description,
    required ExpenseListType type,
    required SplitType splitType,
    required List<String> participantNames,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = _ref.read(authProvider).user;
      if (user == null) {
        throw Exception('Debes iniciar sesión para crear una lista');
      }

      final newList = await _repository.createList(
        name: name,
        description: description,
        type: type,
        splitType: splitType,
        participantNames: participantNames,
        creatorUserId: user.id,
        creatorName: user.fullName,
      );

      final nuevasListas = [...state.lists, newList];
      final nuevaDistribucion = Map<ExpenseListType, int>.from(state.categoryDistribution);
      nuevaDistribucion[newList.type] = (nuevaDistribucion[newList.type] ?? 0) + 1;

      state = state.copyWith(
        lists: nuevasListas,
        categoryDistribution: nuevaDistribucion,
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

final expenseListsProvider =
    StateNotifierProvider<ExpenseListsNotifier, ExpenseListsState>((ref) {
  final repository = ref.watch(expenseListsRepositoryProvider);
  final userId = ref.watch(authProvider).user?.id ?? '';
  return ExpenseListsNotifier(repository, userId, ref);
});