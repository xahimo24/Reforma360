import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reforma360/src/core/routes/app_router.dart';
import 'package:reforma360/src/core/theme/app_theme.dart';

void main() {
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
      // Tema claro
      theme: AppTheme.whiteBlackLightTheme,
      // Tema oscuro
      darkTheme: AppTheme.whiteBlackDarkTheme,
      // Para respetar el modo del sistema (claro/oscuro)
      themeMode: ThemeMode.system,
    );
  }
}
