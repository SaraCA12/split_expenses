class AppUser {
  final String id;
  final String email;
  final String fullName;
  final String username;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.username,
    required this.createdAt,
  });

  AppUser copyWith({
    String? email,
    String? fullName,
    String? username,
  }) {
    return AppUser(
      id: id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      createdAt: createdAt,
    );
  }
}