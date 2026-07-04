class Expense {
  final String id;
  final String listId;
  final String name;
  final double amount;
  final String paidById; // id del Participant que pagó
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.listId,
    required this.name,
    required this.amount,
    required this.paidById,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      listId: json['listId'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      paidById: json['paidById'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'listId': listId,
        'name': name,
        'amount': amount,
        'paidById': paidById,
        'createdAt': createdAt.toIso8601String(),
      };
}