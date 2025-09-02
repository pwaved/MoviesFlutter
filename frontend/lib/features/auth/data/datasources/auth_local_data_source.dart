import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';

class AuthLocalDataSource {
  static const _tokenKey = 'token';
  static const _userIdKey = 'userId';
  static const _emailKey = 'userEmail';

  Future<void> cacheUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, user.token);
    await prefs.setInt(_userIdKey, user.id);
    await prefs.setString(_emailKey, user.email);
  }

  Future<UserEntity?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final id = prefs.getInt(_userIdKey);
    final email = prefs.getString(_emailKey);

    if (token != null && id != null && email != null) {
      return UserEntity(id: id, email: email, token: token);
    }
    return null;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
  }
}
