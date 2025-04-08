import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/remote/auth_remote_ds.dart';
import '../../../data/models/auth/user_model.dart';

final authRemoteDataSourceProvider = Provider((ref) => AuthRemoteDataSource());

final registerProvider = FutureProvider.family.autoDispose<bool, RegisterRequest>((ref, request) async {
  final dataSource = ref.read(authRemoteDataSourceProvider);
  return await dataSource.registerUser(request);
});
