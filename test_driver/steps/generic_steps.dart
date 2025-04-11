import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:flutter_test/flutter_test.dart';

List<StepDefinitionGeneric> getGenericSteps() {
  return [
    Given1<String>('el usuario ve el texto {string}', (input, context) async {
      final finder = find.text(input);
      expect(finder, findsOneWidget);
    }),
    When1<String>('el usuario pulsa el botón con texto {string}', (input, context) async {
      final finder = find.text(input);
      await context.world.driver.tap(finder);
    }),
    Then1<String>('debería navegar a la página con texto {string}', (input, context) async {
      final finder = find.text(input);
      await Future.delayed(Duration(seconds: 1)); // esperar navegación
      expect(finder, findsOneWidget);
    }),
  ];
}
