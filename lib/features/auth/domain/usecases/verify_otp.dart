import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/entities/user.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtp extends UseCase<User, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) {
    return repository.verifyOtp(params.verificationId, params.smsCode);
  }
}

class VerifyOtpParams {
  final String verificationId;
  final String smsCode;

  const VerifyOtpParams({
    required this.verificationId,
    required this.smsCode,
  });
}
