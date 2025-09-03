import 'package:movies_fullstack/features/auth/domain/entities/user_entity.dart';
import 'package:movies_fullstack/features/auth/domain/repositories/auth_repository.dart';


class GetLoggedUser {
  final AuthRepository repository;

  GetLoggedUser(this.repository);

  Future<UserEntity?> call() {
    return repository.getLoggedUser();
  }
}
