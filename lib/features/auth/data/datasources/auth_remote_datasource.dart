import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> sendOtp(String phoneNumber);
  Future<UserModel> verifyOtp(String verificationId, String smsCode);
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<UserModel?> getCurrentUser();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  UserModel _userModelFromFirebaseUser(
    firebase_auth.User user,
    String provider,
  ) {
    return UserModel(
      id: user.uid,
      phoneNumber: user.phoneNumber ?? '',
      createdAtTimestamp: DateTime.now().millisecondsSinceEpoch,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      authProvider: provider,
    );
  }

  // ── Phone Auth ─────────────────────────────────────────────────────────

  @override
  Future<String> sendOtp(String phoneNumber) async {
    try {
      String? verificationId;
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          throw ServerException(e.message ?? 'Verification failed');
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (verificationId == null) {
        throw const ServerException('Failed to send OTP');
      }

      return verificationId!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Failed to send OTP');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> verifyOtp(String verificationId, String smsCode) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const ServerException('User not found after verification');
      }

      return _userModelFromFirebaseUser(userCredential.user!, 'phone');
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Failed to verify OTP');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  // ── Google Sign-In ─────────────────────────────────────────────────────

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const ServerException('Google sign-in cancelled');
      }

      final googleAuth = await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const ServerException('Failed to sign in with Google');
      }

      return _userModelFromFirebaseUser(userCredential.user!, 'google');
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Google sign-in failed');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  // ── Apple Sign-In ──────────────────────────────────────────────────────

  @override
  Future<UserModel> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential =
          firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(oauthCredential);

      if (userCredential.user == null) {
        throw const ServerException('Failed to sign in with Apple');
      }

      // Apple only provides name on first sign-in
      final user = userCredential.user!;
      if (appleCredential.givenName != null && user.displayName == null) {
        final fullName =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim();
        if (fullName.isNotEmpty) {
          await user.updateDisplayName(fullName);
          await user.reload();
        }
      }

      return _userModelFromFirebaseUser(
        firebaseAuth.currentUser ?? user,
        'apple',
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const ServerException('Apple sign-in cancelled');
      }
      throw ServerException(e.message);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Apple sign-in failed');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  // ── Common ─────────────────────────────────────────────────────────────

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      String provider = 'phone';
      for (final info in firebaseUser.providerData) {
        if (info.providerId == 'google.com') {
          provider = 'google';
          break;
        } else if (info.providerId == 'apple.com') {
          provider = 'apple';
          break;
        }
      }

      return _userModelFromFirebaseUser(firebaseUser, provider);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
