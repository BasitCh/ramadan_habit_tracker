import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 10)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String phoneNumber;

  @HiveField(2)
  final int createdAtTimestamp;

  @HiveField(3)
  final String? displayName;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final String? photoUrl;

  @HiveField(6)
  final String authProvider;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.createdAtTimestamp,
    this.displayName,
    this.email,
    this.photoUrl,
    this.authProvider = 'phone',
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      phoneNumber: user.phoneNumber,
      createdAtTimestamp: user.createdAt.millisecondsSinceEpoch,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoUrl,
      authProvider: user.authProvider,
    );
  }

  User toEntity() {
    return User(
      id: id,
      phoneNumber: phoneNumber,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp),
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      authProvider: authProvider,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      createdAtTimestamp: json['createdAt'] as int,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      authProvider: json['authProvider'] as String? ?? 'phone',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'createdAt': createdAtTimestamp,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'authProvider': authProvider,
    };
  }
}
