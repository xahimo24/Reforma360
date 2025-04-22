import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Páginas
import 'package:reforma360/src/presentation/pages/auth/login_page.dart';
import 'package:reforma360/src/presentation/pages/auth/register_page.dart';
import 'package:reforma360/src/presentation/pages/auth/recover_password_page.dart';
import 'package:reforma360/src/presentation/pages/home/home_page.dart';
import 'package:reforma360/src/presentation/pages/feed/feed_page.dart';
import 'package:reforma360/src/presentation/pages/notification/notification_page.dart';
import 'package:reforma360/src/presentation/pages/messages/messages_menu_page.dart';
import 'package:reforma360/src/presentation/pages/profile/profile_page.dart';
import 'package:reforma360/src/presentation/pages/profile/edit_profile_page.dart';

// Provider user
import 'package:reforma360/src/presentation/providers/auth/auth_provider.dart';

import 'route_names.dart';

/// Proveedor que devuelve una instancia única de GoRouter
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.login,

    // —— Redirecciones de sesión ——
    redirect: (context, state) {
      final user = ref.read(userProvider);
      final loc = state.uri.path;

      final isAuthRoute =
          loc == RouteNames.login ||
          loc == RouteNames.register ||
          loc == RouteNames.recoverPassword;

      // No logueado → solo puede ir a rutas de auth
      if (user == null && !isAuthRoute) return RouteNames.login;

      // Logueado → si intenta ir a login / register lo mando a home
      if (user != null && isAuthRoute) return RouteNames.home;

      return null; // sin cambios
    },

    // —— Declaración de rutas ——
    routes: [
      // AUTH
      GoRoute(path: RouteNames.login, builder: (_, __) => const LoginPage()),
      GoRoute(
        path: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.recoverPassword,
        builder: (_, __) => const RecoverPasswordPage(),
      ),

      // MAIN SCREENS
      GoRoute(path: RouteNames.home, builder: (_, __) => const HomePage()),
      GoRoute(path: RouteNames.feed, builder: (_, __) => const FeedPage()),
      GoRoute(
        path: RouteNames.notifications,
        builder: (_, __) => const NotificationPage(),
      ),
      GoRoute(
        path: RouteNames.messages,
        builder: (_, __) => const MessagesPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (_, __) => const ProfilePage(),
      ),

      // EDIT PROFILE (extra recibe Map con los datos)
      GoRoute(
        path: RouteNames.editProfile,
        name: 'editProfile',
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
  );
});
