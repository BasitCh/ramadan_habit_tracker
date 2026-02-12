import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> setAuthenticated(bool value);
  Future<bool> isAuthenticated();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> userBox;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.userBox,
    required this.sharedPreferences,
  });

  static const String _userKey = 'current_user';

  @override
  Future<void> cacheUser(UserModel user) async {
    await userBox.put(_userKey, user);
    await sharedPreferences.setString(
      AppConstants.userPhoneKey,
      user.phoneNumber,
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    return userBox.get(_userKey);
  }

  @override
  Future<void> clearCache() async {
    await userBox.clear();
    await sharedPreferences.remove(AppConstants.isAuthenticatedKey);
    await sharedPreferences.remove(AppConstants.userPhoneKey);
  }

  @override
  Future<void> setAuthenticated(bool value) async {
    await sharedPreferences.setBool(AppConstants.isAuthenticatedKey, value);
  }

  @override
  Future<bool> isAuthenticated() async {
    return sharedPreferences.getBool(AppConstants.isAuthenticatedKey) ?? false;
  }
}
