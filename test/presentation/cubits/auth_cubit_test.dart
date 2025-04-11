import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:reforma360/src/presentation/cubits/auth_cubit.dart';
import 'package:reforma360/src/domain/usecases/auth/login_user.dart';

void main() {
  group('AuthCubit', () {
    late AuthCubit authCubit;

    setUp(() {
      authCubit = AuthCubit(LoginUseCase());
    });

    blocTest<AuthCubit, AuthState>(
      'emite [Loading, Success] cuando login es exitoso',
      build: () => authCubit,
      act: (cubit) => cubit.login('test@mail.com', '123456'),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
    );
  });
}
