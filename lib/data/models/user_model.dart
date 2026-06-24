class UserModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final int? company;
  final bool isSelfEmployed;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.company,
    required this.isSelfEmployed,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: (json['username'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      role: (json['role'] as String?) ?? '',
      company: json['company'] as int?,
      isSelfEmployed: (json['is_self_employed'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'company': company,
      'is_self_employed': isSelfEmployed,
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isContractor => role == 'contractor';
}