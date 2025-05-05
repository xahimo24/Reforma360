import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/remote/auth_remote_ds.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../data/models/auth/register_request.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/auth/login_user.dart';
import '../../../data/repositories/auth_repository_impl.dart';

final authRemoteDataSourceProvider = Provider((ref) => AuthRemoteDataSource());

// REGISTRO
final registerProvider = FutureProvider.family
    .autoDispose<int, RegisterRequest>((ref, request) async {
      final dataSource = ref.read(authRemoteDataSourceProvider);
      return await dataSource.registerUser(request);
    });

// LOGIN
final loginProvider = FutureProvider.family
    .autoDispose<UserModel, Map<String, String>>((ref, credentials) async {
      final dataSource = ref.read(authRemoteDataSourceProvider);
      return await dataSource.loginUser(
        email: credentials['email']!,
        password: credentials['password']!,
      );
    });

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

final loginUserUseCaseProvider = Provider<LoginUser>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUser(repo);
});

final userProvider = StateProvider<UserModel?>((ref) => null);
