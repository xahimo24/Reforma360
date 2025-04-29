import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/core/routes/app_router.dart';
import 'src/data/models/auth/user_model.dart';
import 'src/presentation/providers/auth/auth_provider.dart';
import 'package:reforma360/src/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storedUser = await _loadUser();

  runApp(
    ProviderScope(
      overrides: [
        // Si quieres un userProvider global, puedes sobreescribir su estado inicial
        userProvider.overrideWith((ref) => storedUser),
      ],
      child: const Reforma360App(),
    ),
  );
}

Future<UserModel?> _loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');
  if (userId == null) return null;
  return UserModel(
    id: userId,
    nom: prefs.getString('nom') ?? '',
    cognoms: prefs.getString('cognoms') ?? '',
    email: prefs.getString('email') ?? '',
    telefon: prefs.getString('telefon') ?? '',
    tipus: prefs.getBool('tipus') ?? false,
    foto: prefs.getString('foto') ?? '',
  );
}

class Reforma360App extends ConsumerWidget {
  const Reforma360App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtenemos la instancia de GoRouter
    final goRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Reforma360',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      // Tema claro
      theme: AppTheme.light,
      // Tema oscuro
      darkTheme: AppTheme.dark,
      // Para respetar el modo del sistema (claro/oscuro)
      themeMode: ThemeMode.system,
    );
  }
}
