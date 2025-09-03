import 'package:movies_fullstack/features/auth/domain/entities/user_entity.dart';
import 'package:movies_fullstack/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_fullstack/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:movies_fullstack/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await remoteDataSource.login(email, password);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearCache();
  }

  @override
  Future<UserEntity?> getLoggedUser() async {
    return await localDataSource.getCachedUser();
  }
}
