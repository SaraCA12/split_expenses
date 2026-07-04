import '../../../shared/models/participant.dart';
import '../../../shared/models/expense.dart';

class ParticipantBalance {
  final String participantId;
  final String participantName;
  final double totalPaid;
  final double balance; // + verde (le deben), - rojo (debe)

  const ParticipantBalance({
    required this.participantId,
    required this.participantName,
    required this.totalPaid,
    required this.balance,
  });

  bool get isPositive => balance >= 0;
}

class BalanceCalculator {
  /// Balance = lo que pagó la persona - el promedio del gasto total
  static List<ParticipantBalance> calculate({
    required List<Participant> participants,
    required List<Expense> expenses,
  }) {
    if (participants.isEmpty) return [];

    final totalGastado = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final promedio = totalGastado / participants.length;

    return participants.map((p) {
      final pagadoPorEl = expenses
          .where((e) => e.paidById == p.id)
          .fold<double>(0, (sum, e) => sum + e.amount);

      final balance = pagadoPorEl - promedio;

      return ParticipantBalance(
        participantId: p.id,
        participantName: p.name,
        totalPaid: double.parse(pagadoPorEl.toStringAsFixed(2)),
        balance: double.parse(balance.toStringAsFixed(2)),
      );
    }).toList();
  }

  /// Balance general de la lista: suma de los negativos (lo que falta cuadrar)
  static double totalListBalance(List<ParticipantBalance> balances) {
    final negativos = balances
        .where((b) => b.balance < 0)
        .fold<double>(0, (sum, b) => sum + b.balance);
    return double.parse(negativos.toStringAsFixed(2));
  }
}