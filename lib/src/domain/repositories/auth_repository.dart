import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginUser({
    required String email,
    required String password,
  });
}
