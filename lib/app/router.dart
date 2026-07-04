import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/landing_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/recover_password_screen.dart';
import '../features/auth/presentation/auth_provider.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/expense_lists/presentation/expense_lists_screen.dart';
import '../features/expense_lists/presentation/create_expense_list_screen.dart';
import '../features/expense_list_detail/presentation/expense_list_detail_screen.dart';
import '../features/my_expenses/presentation/my_expenses_screen.dart';

/// Rutas fijas de la app — un solo lugar de verdad para no regar strings sueltos.
class AppRoutes {
  static const splash = '/';
  static const landing = '/landing';
  static const login = '/login';
  static const register = '/register';
  static const recoverPassword = '/recover-password';
  static const home = '/home';
  static const profile = '/profile';
  static const expenseLists = '/expense-lists';
  static const createExpenseList = '/expense-lists/create';
  static const expenseListDetail = '/expense-lists/:listId';
  static const myExpenses = '/my-expenses';

  static String expenseListDetailPath(String listId) => '/expense-lists/$listId';
}

/// Notifica al router cuando cambia el estado de auth, para que
/// go_router reevalúe el `redirect` automáticamente (sin esto,
/// el redirect solo correría en la navegación inicial).
class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthRouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final currentPath = state.matchedLocation;

      final isPublicRoute = currentPath == AppRoutes.splash ||
          currentPath == AppRoutes.landing ||
          currentPath == AppRoutes.login ||
          currentPath == AppRoutes.register ||
          currentPath == AppRoutes.recoverPassword;

      // No autenticado intentando entrar a una ruta protegida -> landing
      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.landing;
      }

      // Autenticado pero está en login/registro/landing -> mándalo a home
      final isAuthOnlyRoute = currentPath == AppRoutes.landing ||
          currentPath == AppRoutes.login ||
          currentPath == AppRoutes.register ||
          currentPath == AppRoutes.recoverPassword;

      if (isAuthenticated && isAuthOnlyRoute) {
        return AppRoutes.home;
      }

      return null; // sin redirección
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.landing,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.recoverPassword,
        builder: (context, state) => const RecoverPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.expenseLists,
        builder: (context, state) => const ExpenseListsScreen(),
      ),
      GoRoute(
        path: AppRoutes.createExpenseList,
        builder: (context, state) => const CreateExpenseListScreen(),
      ),
      GoRoute(
        path: AppRoutes.expenseListDetail,
        builder: (context, state) {
          final listId = state.pathParameters['listId']!;
          return ExpenseListDetailScreen(listId: listId);
        },
      ),
      GoRoute(
        path: AppRoutes.myExpenses,
        builder: (context, state) => const MyExpensesScreen(),
      ),
    ],
  );
});