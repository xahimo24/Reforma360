import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔥 Firebase inicializado correctamente");
  runApp(const ProviderScope(child: Reforma360App()));
}

class Reforma360App extends StatelessWidget {
  const Reforma360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reforma360',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
