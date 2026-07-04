import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/models/participant.dart';
import 'expense_list_detail_provider.dart';

void showAddExpenseSheet(BuildContext context, WidgetRef ref, String listId, List<Participant> participants) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _AddExpenseSheet(listId: listId, participants: participants),
  );
}

class _AddExpenseSheet extends ConsumerStatefulWidget {
  final String listId;
  final List<Participant> participants;

  const _AddExpenseSheet({required this.listId, required this.participants});

  @override
  ConsumerState<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<_AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedPayerId;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedPayerId = widget.participants.isNotEmpty ? widget.participants.first.id : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPayerId == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;

    final success = await ref.read(expenseListDetailProvider(widget.listId).notifier).addExpense(
          name: _nameController.text.trim(),
          amount: amount,
          paidById: _selectedPayerId!,
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop();
    } else if (mounted) {
      setState(() {
        _errorMessage = ref.read(expenseListDetailProvider(widget.listId)).errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Agregar nuevo gasto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 20),

              Text('Nombre del gasto', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Ej. Cena en la playa'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 16),

              Text('Monto', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(prefixText: '\$ ', hintText: '0.00'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
                  final parsed = double.tryParse(v.replaceAll(',', '.'));
                  if (parsed == null) return 'Monto inválido';
                  if (parsed <= 0) return 'El monto debe ser mayor a cero';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Text('¿Quién pagó?', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPayerId,
                items: widget.participants
                    .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedPayerId = value),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(_errorMessage!, style: TextStyle(color: AppColors.negative)),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Agregar gasto'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}