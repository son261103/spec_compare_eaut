import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String username;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;
  final String syncStatus;
  final DateTime lastSyncedAt;
  String roleId;

  User({
    String? userId,
    required this.username,
    required this.email,
    this.profileImageUrl,
    DateTime? createdAt,
    this.lastLoginAt,
    this.isActive = true,
    this.syncStatus = 'pending',
    DateTime? lastSyncedAt,
    this.roleId = '',
  }) :
        this.userId = userId ?? Uuid().v4(),
        this.createdAt = createdAt ?? DateTime.now(),
        this.lastSyncedAt = lastSyncedAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null
          ? (json['lastLoginAt'] is Timestamp
          ? (json['lastLoginAt'] as Timestamp).toDate()
          : DateTime.parse(json['lastLoginAt']))
          : null,
      isActive: json['isActive'],
      syncStatus: json['syncStatus'],
      lastSyncedAt: json['lastSyncedAt'] is Timestamp
          ? (json['lastSyncedAt'] as Timestamp).toDate()
          : DateTime.parse(json['lastSyncedAt']),
      roleId: json['roleId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'isActive': isActive,
      'syncStatus': syncStatus,
      'lastSyncedAt': Timestamp.fromDate(lastSyncedAt),
      'roleId': roleId,
    };
  }
}