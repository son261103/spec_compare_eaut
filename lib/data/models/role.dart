import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  final String roleId;
  final String name;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String syncStatus;
  final DateTime lastSyncedAt;
  final bool isDefault;

  Role({
    String? roleId,
    required this.name,
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.syncStatus = 'pending',
    DateTime? lastSyncedAt,
    this.isDefault = false,
  }) :
        this.roleId = roleId ?? Uuid().v4(),
        this.createdAt = createdAt ?? DateTime.now(),
        this.lastUpdated = lastUpdated ?? DateTime.now(),
        this.lastSyncedAt = lastSyncedAt ?? DateTime.now();

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['roleId'],
      name: json['name'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt']),
      lastUpdated: json['lastUpdated'] is Timestamp
          ? (json['lastUpdated'] as Timestamp).toDate()
          : DateTime.parse(json['lastUpdated']),
      syncStatus: json['syncStatus'],
      lastSyncedAt: json['lastSyncedAt'] is Timestamp
          ? (json['lastSyncedAt'] as Timestamp).toDate()
          : DateTime.parse(json['lastSyncedAt']),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'syncStatus': syncStatus,
      'lastSyncedAt': Timestamp.fromDate(lastSyncedAt),
      'isDefault': isDefault,
    };
  }
}