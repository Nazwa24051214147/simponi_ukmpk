import 'member_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final bool isActive;
  final bool mustChangePassword;
  final List<String> roles;
  final MemberModel? member;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    required this.mustChangePassword,
    required this.roles,
    this.member,
  });

  bool get isAdmin => roles.contains('admin');
  bool get isPengurus => roles.contains('pengurus');
  bool get isAnggota => roles.contains('anggota');

  String get primaryRole {
    if (isAdmin) return 'admin';
    if (isPengurus) return 'pengurus';
    if (isAnggota) return 'anggota';
    return roles.isNotEmpty ? roles.first : 'anggota';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      mustChangePassword: json['must_change_password'] == true ||
          json['must_change_password'] == 1,
      roles: (json['roles'] as List<dynamic>? ?? [])
          .map((role) {
            if (role is Map<String, dynamic>) {
              return role['name']?.toString() ?? '';
            }
            return role.toString();
          })
          .where((r) => r.isNotEmpty)
          .toList(),
      member: json['member'] is Map<String, dynamic>
          ? MemberModel.fromJson(json['member'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'is_active': isActive,
      'must_change_password': mustChangePassword,
      'roles': roles,
      'member': member?.toJson(),
    };
  }
}
