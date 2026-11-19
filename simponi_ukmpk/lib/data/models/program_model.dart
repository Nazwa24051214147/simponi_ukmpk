import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ProgramModel {
  final int id;
  final int divisionId;
  final String divisionName;
  final int? picId;
  final String? picName;
  final String? picNim;
  final String name;
  final String? description;
  final int? quota;
  final String registrationType;
  final String? registrationStart;
  final String? registrationEnd;
  final String? startDate;
  final String? endDate;
  final String? location;
  final String status;
  final int membersCount;
  final int schedulesCount;

  ProgramModel({
    required this.id,
    required this.divisionId,
    required this.divisionName,
    this.picId,
    this.picName,
    this.picNim,
    required this.name,
    this.description,
    this.quota,
    this.registrationType = 'Internal',
    this.registrationStart,
    this.registrationEnd,
    this.startDate,
    this.endDate,
    this.location,
    this.status = 'Planned',
    this.membersCount = 0,
    this.schedulesCount = 0,
  });

  String get statusLabel {
    switch (status) {
      case 'Preparation':
        return 'Persiapan';
      case 'Ongoing':
        return 'Berlangsung';
      case 'Completed':
        return 'Selesai';
      case 'Cancelled':
        return 'Dibatalkan';
      case 'Planned':
      default:
        return 'Perencanaan';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'Preparation':
        return AppTheme.teal;
      case 'Ongoing':
        return Colors.green.shade700;
      case 'Completed':
        return AppTheme.deepNavy;
      case 'Cancelled':
        return AppTheme.softTerracotta;
      case 'Planned':
      default:
        return Colors.blueGrey;
    }
  }

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    final division = json['division'] as Map<String, dynamic>?;
    final pic = json['pic'] as Map<String, dynamic>?;
    final picUser = pic?['user'] as Map<String, dynamic>?;

    return ProgramModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      divisionId: json['division_id'] is int
          ? json['division_id'] as int
          : int.tryParse(json['division_id']?.toString() ?? '0') ?? 0,
      divisionName: division?['name']?.toString() ?? 'Divisi',
      picId: json['pic_id'] is int
          ? json['pic_id'] as int
          : int.tryParse(json['pic_id']?.toString() ?? ''),
      picName: picUser?['name']?.toString(),
      picNim: pic?['nim']?.toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      quota: json['quota'] is int
          ? json['quota'] as int
          : int.tryParse(json['quota']?.toString() ?? ''),
      registrationType: json['registration_type']?.toString() ?? 'Internal',
      registrationStart: json['registration_start']?.toString(),
      registrationEnd: json['registration_end']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      location: json['location']?.toString(),
      status: json['status']?.toString() ?? 'Planned',
      membersCount: int.tryParse(
            json['members_count']?.toString() ?? '0',
          ) ??
          0,
      schedulesCount: int.tryParse(
            json['schedules_count']?.toString() ?? '0',
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'division_id': divisionId,
      'pic_id': picId,
      'name': name,
      'description': description,
      'quota': quota,
      'registration_type': registrationType,
      'registration_start': registrationStart,
      'registration_end': registrationEnd,
      'start_date': startDate,
      'end_date': endDate,
      'location': location,
      'status': status,
    };
  }
}
