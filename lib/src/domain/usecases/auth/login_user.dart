import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.loginUser(email: email, password: password);
  }
}
