import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/entities/user.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/check_auth_status.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/logout.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/send_otp.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/verify_otp.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatus checkAuthStatus;
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;
  final Logout logout;

  AuthBloc({
    required this.checkAuthStatus,
    required this.sendOtp,
    required this.verifyOtp,
    required this.signInWithGoogle,
    required this.signInWithApple,
    required this.logout,
  }) : super(const AuthInitial()) {
    on<CheckAuthStatusRequested>(_onCheckAuthStatus);
    on<SendOtpRequested>(_onSendOtp);
    on<VerifyOtpRequested>(_onVerifyOtp);
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<AppleSignInRequested>(_onAppleSignIn);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await checkAuthStatus(const NoParams());

    result.fold(
      (failure) => emit(const Unauthenticated()),
      (isAuthenticated) {
        if (isAuthenticated) {
          emit(Authenticated(
            User(
              id: 'authenticated_user',
              phoneNumber: '',
              createdAt: DateTime.now(),
            ),
          ));
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSendOtp(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await sendOtp(SendOtpParams(phoneNumber: event.phoneNumber));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (verificationId) => emit(OtpSent(
        verificationId: verificationId,
        phoneNumber: event.phoneNumber,
      )),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await verifyOtp(VerifyOtpParams(
      verificationId: event.verificationId,
      smsCode: event.smsCode,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signInWithGoogle(const NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onAppleSignIn(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signInWithApple(const NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logout(const NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }
}
