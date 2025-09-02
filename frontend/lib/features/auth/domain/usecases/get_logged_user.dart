import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetLoggedUser {
  final AuthRepository repository;

  GetLoggedUser(this.repository);

  Future<UserEntity?> call() {
    return repository.getLoggedUser();
  }
}
