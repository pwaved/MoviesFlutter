import 'dart:convert';
import 'package:movies_fullstack/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:movies_fullstack/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String CACHED_USER_KEY = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(UserEntity user) {
    final userJson = jsonEncode(user.toJson());
    return sharedPreferences.setString(CACHED_USER_KEY, userJson);
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER_KEY);
    if (jsonString != null) {
      final userMap = jsonDecode(jsonString);
      return UserEntity.fromJson(userMap); 
    } else {
      return null;
    }
  }

  @override
  Future<void> clearCache() {
    return sharedPreferences.remove(CACHED_USER_KEY);
  }
}