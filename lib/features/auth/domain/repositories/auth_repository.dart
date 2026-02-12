import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Send OTP to phone number
  Future<Either<Failure, String>> sendOtp(String phoneNumber);

  /// Verify OTP code
  Future<Either<Failure, User>> verifyOtp(String verificationId, String smsCode);

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle();

  /// Sign in with Apple
  Future<Either<Failure, User>> signInWithApple();

  /// Check if user is authenticated
  Future<Either<Failure, bool>> checkAuthStatus();

  /// Get current user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Logout user
  Future<Either<Failure, void>> logout();
}
