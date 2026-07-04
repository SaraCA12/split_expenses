class Participant {
  final String id;
  final String name;

  const Participant({
    required this.id,
    required this.name,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Participant && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}