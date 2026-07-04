import '../models/expense.dart';
import '../models/expense_list.dart';
import '../models/user.dart';

/// Única fuente de verdad en memoria para todo el mock backend.
/// Todos los repositorios leen/escriben aquí para mantener consistencia.
class MockDatabase {
  MockDatabase._() {
    _seedTestUser();
  }
  static final MockDatabase instance = MockDatabase._();

  final List<ExpenseList> lists = [];
  final List<Expense> expenses = [];
  final List<AppUser> users = [];
  final Map<String, String> passwordsByUserId = {}; // userId -> password

  void _seedTestUser() {
    final testUser = AppUser(
      id: 'test_user_1',
      email: 'test@test.com',
      fullName: 'sara calderon',
      username: 'sarac',
      createdAt: DateTime.now(),
    );
    users.add(testUser);
    passwordsByUserId[testUser.id] = '123456';
  }
}