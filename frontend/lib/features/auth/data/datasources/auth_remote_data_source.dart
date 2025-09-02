import 'package:movies_fullstack/api/backend_api_service.dart';
import '../../domain/entities/user_entity.dart';

class AuthRemoteDataSource {
  final BackendApiService api;

  AuthRemoteDataSource(this.api);

  Future<UserEntity> login(String email, String password) async {
    final response = await api.login(email, password);
    return UserEntity(
      id: response['user']['id'],
      email: response['user']['email'],
      token: response['token'],
    );
  }
}
