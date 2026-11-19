class MemberModel {
  final int id;
  final int userId;
  final String nim;
  final String? phone;
  final int divisionId;
  final String position;
  final String generation;
  final String status;
  final String? divisionName;

  MemberModel({
    required this.id,
    required this.userId,
    required this.nim,
    this.phone,
    required this.divisionId,
    required this.position,
    required this.generation,
    required this.status,
    this.divisionName,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      nim: json['nim']?.toString() ?? '',
      phone: json['phone']?.toString(),
      divisionId: json['division_id'] is int
          ? json['division_id']
          : int.tryParse(json['division_id']?.toString() ?? '0') ?? 0,
      position: json['position']?.toString() ?? '',
      generation: json['generation']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Active',
      divisionName: json['division'] is Map<String, dynamic>
          ? json['division']['name']?.toString()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nim': nim,
      'phone': phone,
      'division_id': divisionId,
      'position': position,
      'generation': generation,
      'status': status,
      if (divisionName != null) 'division_name': divisionName,
    };
  }
}
