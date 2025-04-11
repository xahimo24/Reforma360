import 'package:flutter_test/flutter_test.dart';
import 'package:reforma360/src/domain/usecases/auth/login_user.dart';
import 'package:reforma360/src/domain/entities/user_entity.dart';

void main() {
  test('debería retornar un usuario válido cuando login es correcto', () async {
    final usecase = LoginUser(); // Asegúrate de usar un mock de repositorio dentro si es necesario
    final result = await usecase.call(email: 'test@mail.com', password: '123456');

    expect(result, isA<UserEntity>());
    expect(result.email, 'test@mail.com');
  });
}
