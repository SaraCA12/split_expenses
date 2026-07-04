import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../../../../shared/models/user.dart';

/// Provider del repositorio (uno solo, reutilizado por todos los notifiers de auth)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Estado de autenticación de la app completa.
class AuthState {
  final AppUser? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<bool> login({
    required String emailOrUsername,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.login(
        emailOrUsername: emailOrUsername,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String fullName,
    required String username,
    required String password,
    required String repeatPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.register(
        email: email,
        fullName: fullName,
        username: username,
        password: password,
        repeatPassword: repeatPassword,
      );
      state = state.copyWith(isLoading: false);
      return true; // éxito -> la UI redirige a login
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> recoverPassword({required String email}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.recoverPassword(email: email);
      state = state.copyWith(isLoading: false);
      return true; // éxito -> la UI redirige a login
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> updateProfile({
    required String email,
    required String fullName,
    required String username,
  }) async {
    if (state.user == null) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final updated = await _repository.updateProfile(
        userId: state.user!.id,
        email: email,
        fullName: fullName,
        username: username,
      );
      state = state.copyWith(user: updated, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(); // resetea todo, incluyendo user a null
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});