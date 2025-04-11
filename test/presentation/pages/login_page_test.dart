import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reforma360/src/presentation/pages/auth/login_page.dart';

void main() {
  testWidgets('renderiza inputs de email y contraseña y el botón de login',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginPage()),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
