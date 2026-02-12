import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final DateTime createdAt;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String authProvider; // 'phone', 'google', 'apple'

  const User({
    required this.id,
    required this.phoneNumber,
    required this.createdAt,
    this.displayName,
    this.email,
    this.photoUrl,
    this.authProvider = 'phone',
  });

  @override
  List<Object?> get props =>
      [id, phoneNumber, createdAt, displayName, email, photoUrl, authProvider];

  User copyWith({
    String? id,
    String? phoneNumber,
    DateTime? createdAt,
    String? displayName,
    String? email,
    String? photoUrl,
    String? authProvider,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider ?? this.authProvider,
    );
  }
}
