import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reforma360/src/presentation/widgets/custom_button.dart';

void main() {
  testWidgets('custom button muestra el texto y responde al click',
      (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Aceptar',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Aceptar'), findsOneWidget);
    await tester.tap(find.text('Aceptar'));
    expect(pressed, true);
  });
}
