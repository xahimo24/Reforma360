import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:integration_test/integration_test.dart';
import 'steps/generic_steps.dart'; // Tus pasos personalizados

Future<void> main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final config = FlutterTestConfiguration()
    ..features = [RegExp(r'lib/gherkin/.*\.feature')]
    ..reporters = [ProgressReporter()]
    ..stepDefinitions = [
      ...getGenericSteps(), // <-- función que retorna tus steps
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";

  return GherkinRunner().execute(config);
}
