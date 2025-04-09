import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Páginas
import 'package:reforma360/src/presentation/pages/auth/login_page.dart';
import 'package:reforma360/src/presentation/pages/auth/register_page.dart';
import 'package:reforma360/src/presentation/pages/home/home_page.dart';
import 'package:reforma360/src/presentation/pages/auth/recover_password_page.dart';
import 'package:reforma360/src/presentation/pages/feed/feed_page.dart';
import 'package:reforma360/src/presentation/pages/notification/notification_page.dart';
import 'package:reforma360/src/presentation/pages/messages/messages_menu_page.dart';

// Provider donde está tu usuario (debes crearlo si no existe)
import 'package:reforma360/src/presentation/providers/auth/auth_provider.dart';

import 'route_names.dart';

/// PROVEDOR global para crear/retornar tu GoRouter
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Empezamos en /login o donde prefieras
    initialLocation: RouteNames.login,

    // Aquí hacemos la lógica de redirección
    redirect: (context, state) {
      // Leemos el usuario desde userProvider
      final user = ref.read(userProvider);

      // Obtenemos la ruta actual:
      final location = state.uri.path;
      // Rutas que SÍ permitimos cuando user == null
      // (por ejemplo login, register, recover password)
      final goingToLogin =
          location == RouteNames.login ||
          location == RouteNames.register ||
          location == RouteNames.recoverPassword;

      // Si NO está logueado y NO va a /login o /register => manda a login
      if (user == null && !goingToLogin) {
        return RouteNames.login;
      }

      // Si SÍ está logueado y va a /login o /register => manda a /home
      if (user != null && goingToLogin) {
        return RouteNames.home;
      }

      // Si no cumplimos ninguna de esas condiciones, no redirigimos
      return null;
    },

    // Definimos las rutas
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.recoverPassword,
        name: 'recoverPassword',
        builder: (context, state) => const RecoverPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.feed,
        name: 'feed',
        builder: (context, state) => const FeedPage(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: RouteNames.messages,
        name: 'messages',
        builder: (context, state) => const MessagesPage(),
      ),
    ],
  );
});
