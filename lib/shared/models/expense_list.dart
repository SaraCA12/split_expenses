import 'participant.dart';

enum ExpenseListType { viaje, restaurante, mercado, casa, otro }

enum SplitType { promedio, porConsumo }
// Nota: por ahora BalanceCalculator solo implementa "promedio".
// "porConsumo" queda guardado en el modelo para soportarlo a futuro.

class ExpenseList {
  final String id;
  final String name;
  final String description;
  final ExpenseListType type;
  final SplitType splitType;
  final List<Participant> participants;
  final DateTime createdAt;

  const ExpenseList({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.splitType,
    required this.participants,
    required this.createdAt,
  });

  ExpenseList copyWith({
    String? name,
    String? description,
    ExpenseListType? type,
    SplitType? splitType,
    List<Participant>? participants,
  }) {
    return ExpenseList(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      splitType: splitType ?? this.splitType,
      participants: participants ?? this.participants,
      createdAt: createdAt,
    );
  }
}