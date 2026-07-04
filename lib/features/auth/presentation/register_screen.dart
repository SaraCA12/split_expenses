import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../app/router.dart';
import 'auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).register(
          email: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          repeatPassword: _repeatPasswordController.text,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada. Ahora inicia sesión.')),
      );
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Crea tu cuenta',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Empieza a organizar tus gastos', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  const SizedBox(height: 28),

                  _FieldLabel('Nombre completo'),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(hintText: 'Ej. Sara Castro'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
                  ),
                  const SizedBox(height: 16),

                  _FieldLabel('Nombre de usuario'),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(hintText: 'Ej. saraca12'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
                  ),
                  const SizedBox(height: 16),

                  _FieldLabel('Email'),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'tucorreo@ejemplo.com'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
                      if (!v.contains('@') || !v.contains('.')) return 'Email inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _FieldLabel('Contraseña'),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: '••••••••'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Campo obligatorio';
                      if (v.length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _FieldLabel('Repite tu contraseña'),
                  TextFormField(
                    controller: _repeatPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: '••••••••'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Campo obligatorio';
                      if (v != _passwordController.text) return 'Las contraseñas no coinciden';
                      return null;
                    },
                  ),

                  if (authState.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.negative.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(authState.errorMessage!,
                          style: TextStyle(color: AppColors.negative, fontWeight: FontWeight.w500)),
                    ),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleRegister,
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Registrarse'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    );
  }
}