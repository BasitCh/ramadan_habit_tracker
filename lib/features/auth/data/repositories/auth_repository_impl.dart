import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ramadan_habit_tracker/features/auth/data/models/user_model.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/entities/user.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> sendOtp(String phoneNumber) async {
    try {
      final verificationId = await remoteDataSource.sendOtp(phoneNumber);
      return Right(verificationId);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final userModel = await remoteDataSource.verifyOtp(
        verificationId,
        smsCode,
      );
      await localDataSource.cacheUser(userModel);
      await localDataSource.setAuthenticated(true);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  Future<Either<Failure, User>> _handleSocialSignIn(
    Future<UserModel> Function() signInFn,
  ) async {
    try {
      final userModel = await signInFn();
      await localDataSource.cacheUser(userModel);
      await localDataSource.setAuthenticated(true);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() {
    return _handleSocialSignIn(remoteDataSource.signInWithGoogle);
  }

  @override
  Future<Either<Failure, User>> signInWithApple() {
    return _handleSocialSignIn(remoteDataSource.signInWithApple);
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final isAuth = await localDataSource.isAuthenticated();
      return Right(isAuth);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      if (userModel == null) {
        return const Right(null);
      }
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearCache();
      await localDataSource.setAuthenticated(false);

      // Clear user-specific data boxes to prevent data bleeding
      // Note: We use Hive.box directly here to avoid circular dependencies
      // or complex dependency injection changes for this fix.
      try {
        if (Hive.isBoxOpen(AppConstants.prayerLogsBox)) {
          await Hive.box(AppConstants.prayerLogsBox).clear();
        }
        if (Hive.isBoxOpen(AppConstants.quranProgressBox)) {
          await Hive.box(AppConstants.quranProgressBox).clear();
        }
        if (Hive.isBoxOpen(AppConstants.ibadahChecklistBox)) {
          await Hive.box(AppConstants.ibadahChecklistBox).clear();
        }
        if (Hive.isBoxOpen(AppConstants.duaBookmarksBox)) {
          await Hive.box(AppConstants.duaBookmarksBox).clear();
        }
        if (Hive.isBoxOpen(AppConstants.adhkarProgressBox)) {
          await Hive.box(AppConstants.adhkarProgressBox).clear();
        }
      } catch (e) {
        // Ignore errors during cache clearing
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
