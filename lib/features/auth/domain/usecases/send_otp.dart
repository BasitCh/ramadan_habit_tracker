import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/repositories/auth_repository.dart';

class SendOtp extends UseCase<String, SendOtpParams> {
  final AuthRepository repository;

  SendOtp(this.repository);

  @override
  Future<Either<Failure, String>> call(SendOtpParams params) {
    return repository.sendOtp(params.phoneNumber);
  }
}

class SendOtpParams {
  final String phoneNumber;

  const SendOtpParams({required this.phoneNumber});
}
