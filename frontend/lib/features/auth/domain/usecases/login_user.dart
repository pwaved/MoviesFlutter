import 'package:movies_fullstack/features/auth/domain/entities/user_entity.dart';
import 'package:movies_fullstack/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.login(email, password);
  }
}
