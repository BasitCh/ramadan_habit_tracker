import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/entities/user.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/repositories/auth_repository.dart';

class SignInWithApple extends UseCase<User, NoParams> {
  final AuthRepository repository;

  SignInWithApple(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.signInWithApple();
  }
}
