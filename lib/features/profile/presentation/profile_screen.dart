import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/main_bottom_nav.dart';
import '../../../app/router.dart';
import '../../auth/presentation/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _emailController = TextEditingController(text: user?.email ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final success = await ref.read(authProvider.notifier).updateProfile(
          email: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          username: _usernameController.text.trim(),
        );
    if (success && mounted) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado')),
      );
    }
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) context.go(AppRoutes.landing);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back, color: AppColors.primary),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(() => _isEditing = !_isEditing),
                      child: Text(_isEditing ? 'Cancelar' : 'Editar',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(color: AppColors.avatarBg3, shape: BoxShape.circle),
                    child: const Icon(Icons.person_rounded, size: 48, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProfileField(
                            label: 'Nombre completo',
                            controller: _fullNameController,
                            editable: _isEditing,
                          ),
                          const Divider(height: 28),
                          _ProfileField(
                            label: 'Nombre de usuario',
                            controller: _usernameController,
                            editable: _isEditing,
                          ),
                          const Divider(height: 28),
                          _ProfileField(
                            label: 'Email',
                            controller: _emailController,
                            editable: _isEditing,
                          ),
                          const Divider(height: 28),
                          Text('Cuenta creada', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(
                            user != null ? DateFormat('dd/MM/yyyy').format(user.createdAt) : '-',
                            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_isEditing)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _saveChanges,
                      child: authState.isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Guardar cambios'),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: const BorderSide(color: AppColors.negative, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      child: Text('Cerrar sesión', style: TextStyle(color: AppColors.negative, fontWeight: FontWeight.w700)),
                    ),
                  ),
                const SizedBox(height: 12),
                const MainBottomNav(currentIndex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool editable;

  const _ProfileField({required this.label, required this.controller, required this.editable});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        editable
            ? TextField(
                controller: controller,
                decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
              )
            : Text(controller.text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary)),
      ],
    );
  }
}