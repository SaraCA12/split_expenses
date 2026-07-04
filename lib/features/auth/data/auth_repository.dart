import '../../../shared/data/mock_database.dart';
import '../../../shared/models/user.dart';
import '../../../core/utils/id_generator.dart';

class AuthRepository {
  final _db = MockDatabase.instance;

  /// Usuario con sesión activa. null = nadie ha iniciado sesión.
  AppUser? _currentUser;

  Future<AppUser> register({
    required String email,
    required String fullName,
    required String username,
    required String password,
    required String repeatPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    _validateRegisterFields(
      email: email,
      fullName: fullName,
      username: username,
      password: password,
      repeatPassword: repeatPassword,
    );

    final emailExists = _db.users.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (emailExists) {
      throw Exception('Ya existe una cuenta con este email');
    }

    final usernameExists = _db.users.any((u) => u.username.toLowerCase() == username.toLowerCase());
    if (usernameExists) {
      throw Exception('Ese nombre de usuario ya está en uso');
    }

    final newUser = AppUser(
      id: IdGenerator.generate(),
      email: email.trim(),
      fullName: fullName.trim(),
      username: username.trim(),
      createdAt: DateTime.now(),
    );

    _db.users.add(newUser);
    _db.passwordsByUserId[newUser.id] = password;

    return newUser;
  }

  Future<AppUser> login({
    required String emailOrUsername,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final user = _db.users.where((u) =>
        u.email.toLowerCase() == emailOrUsername.toLowerCase() ||
        u.username.toLowerCase() == emailOrUsername.toLowerCase()).firstOrNull;

    if (user == null) {
      throw Exception('Usuario no encontrado');
    }

    final storedPassword = _db.passwordsByUserId[user.id];
    if (storedPassword != password) {
      throw Exception('Contraseña incorrecta');
    }

    _currentUser = user;
    return user;
  }

  Future<void> recoverPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final exists = _db.users.any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (!exists) {
      throw Exception('No existe una cuenta con ese email');
    }
    // Mock: en un backend real esto enviaría un correo.
    // Aquí solo simulamos éxito para redirigir al login.
  }

  Future<AppUser> updateProfile({
    required String userId,
    required String email,
    required String fullName,
    required String username,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _db.users.indexWhere((u) => u.id == userId);
    if (index == -1) {
      throw Exception('Usuario no encontrado');
    }

    final updated = _db.users[index].copyWith(
      email: email.trim(),
      fullName: fullName.trim(),
      username: username.trim(),
    );

    _db.users[index] = updated;
    if (_currentUser?.id == userId) {
      _currentUser = updated;
    }
    return updated;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }

  AppUser? get currentUser => _currentUser;

  void _validateRegisterFields({
    required String email,
    required String fullName,
    required String username,
    required String password,
    required String repeatPassword,
  }) {
    if (email.trim().isEmpty || fullName.trim().isEmpty || username.trim().isEmpty) {
      throw Exception('Todos los campos son obligatorios');
    }
    if (!email.contains('@') || !email.contains('.')) {
      throw Exception('Email inválido');
    }
    if (password.isEmpty) {
      throw Exception('La contraseña es obligatoria');
    }
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }
    if (password != repeatPassword) {
      throw Exception('Las contraseñas no coinciden');
    }
  }
}