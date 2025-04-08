import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_ds.dart';
import '../mappers/auth_mapper.dart'; // Mapper que convierte UserModel a UserEntity

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<UserEntity> loginUser({
    required String email,
    required String password,
  }) async {
    final userModel = await remote.loginUser(email: email, password: password);
    return userModel.toEntity(); // convierte a UserEntity usando el mapper
  }
}
