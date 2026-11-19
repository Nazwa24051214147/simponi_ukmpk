class DivisionMemberItem {
  final int id;
  final int userId;
  final String nim;
  final String? phone;
  final String position;
  final String generation;
  final String status;
  final String userName;
  final String userEmail;

  DivisionMemberItem({
    required this.id,
    required this.userId,
    required this.nim,
    this.phone,
    required this.position,
    required this.generation,
    required this.status,
    required this.userName,
    required this.userEmail,
  });

  bool get isPengurus {
    final pos = position.toLowerCase();
    return pos.contains('kadiv') ||
        pos.contains('kepala') ||
        pos.contains('wakil') ||
        pos.contains('ketua') ||
        pos.contains('koordinator') ||
        pos.contains('bph');
  }

  factory DivisionMemberItem.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return DivisionMemberItem(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      nim: json['nim']?.toString() ?? '',
      phone: json['phone']?.toString(),
      position: json['position']?.toString() ?? 'Anggota',
      generation: json['generation']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Active',
      userName: user?['name']?.toString() ?? '',
      userEmail: user?['email']?.toString() ?? '',
    );
  }
}

class DivisionModel {
  final int id;
  final String name;
  final String? description;
  final int membersCount;
  final List<DivisionMemberItem> members;

  DivisionModel({
    required this.id,
    required this.name,
    this.description,
    this.membersCount = 0,
    this.members = const [],
  });

  factory DivisionModel.fromJson(Map<String, dynamic> json) {
    final rawMembers = json['members'] as List<dynamic>? ?? [];
    return DivisionModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      membersCount: json['members_count'] is int
          ? json['members_count'] as int
          : (rawMembers.isNotEmpty ? rawMembers.length : 0),
      members: rawMembers
          .whereType<Map<String, dynamic>>()
          .map((m) => DivisionMemberItem.fromJson(m))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
