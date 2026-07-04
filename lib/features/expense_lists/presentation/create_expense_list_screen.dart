import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../app/router.dart';
import '../../../shared/models/expense_list.dart';
import 'expense_lists_provider.dart';

class CreateExpenseListScreen extends ConsumerStatefulWidget {
  const CreateExpenseListScreen({super.key});

  @override
  ConsumerState<CreateExpenseListScreen> createState() => _CreateExpenseListScreenState();
}

class _CreateExpenseListScreenState extends ConsumerState<CreateExpenseListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _participantController = TextEditingController();

  ExpenseListType _selectedType = ExpenseListType.viaje;
  SplitType _selectedSplit = SplitType.promedio;
  final List<String> _participants = [];
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _participantController.dispose();
    super.dispose();
  }

  void _addParticipant() {
    final name = _participantController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _participants.add(name);
      _participantController.clear();
    });
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref.read(expenseListsProvider.notifier).createList(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          type: _selectedType,
          splitType: _selectedSplit,
          participantNames: _participants,
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      final createdList = ref.read(expenseListsProvider).lists.last;
      context.go(AppRoutes.expenseListDetailPath(createdList.id));
    } else if (mounted) {
      setState(() => _errorMessage = ref.read(expenseListsProvider).errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_back, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Nueva lista', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text('Nombre de la lista', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Ej. Viaje a la playa'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
                  ),
                  const SizedBox(height: 20),

                  Text('Descripción', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(hintText: 'Ej. Fin de semana con amigos'),
                  ),
                  const SizedBox(height: 20),

                  Text('Tipo', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: ExpenseListType.values.map((type) {
                      return AppChip(
                        label: _typeLabel(type),
                        selected: _selectedType == type,
                        onTap: () => setState(() => _selectedType = type),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  Text('Tipo de repartición', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      AppChip(
                        label: 'Promedio',
                        selected: _selectedSplit == SplitType.promedio,
                        onTap: () => setState(() => _selectedSplit = SplitType.promedio),
                      ),
                      AppChip(
                        label: 'Por consumo',
                        selected: _selectedSplit == SplitType.porConsumo,
                        onTap: () => setState(() => _selectedSplit = SplitType.porConsumo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text('Añadir participantes', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('Tú ya quedas incluido automáticamente como creador', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _participantController,
                          decoration: const InputDecoration(hintText: 'Nombre del participante'),
                          onSubmitted: (_) => _addParticipant(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _addParticipant,
                        icon: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _participants.map((name) {
                      return Chip(
                        label: Text(name),
                        backgroundColor: AppColors.surfaceMuted,
                        onDeleted: () => setState(() => _participants.remove(name)),
                      );
                    }).toList(),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.negative.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(_errorMessage!, style: TextStyle(color: AppColors.negative)),
                    ),
                  ],

                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleCreate,
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Crear lista'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _typeLabel(ExpenseListType type) {
    switch (type) {
      case ExpenseListType.viaje: return 'Viaje';
      case ExpenseListType.restaurante: return 'Restaurante';
      case ExpenseListType.mercado: return 'Mercado';
      case ExpenseListType.casa: return 'Casa';
      case ExpenseListType.otro: return 'Otro';
    }
  }
}