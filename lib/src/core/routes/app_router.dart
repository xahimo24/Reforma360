// file: lib/src/core/routes/app_router.dart

// Importaciones necesarias para el enrutamiento y la gestión de estado
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Importación de las constantes de nombres de rutas
import 'route_names.dart';

// Importaciones de las páginas de autenticación
import 'package:reforma360/src/presentation/pages/auth/login_page.dart';
import 'package:reforma360/src/presentation/pages/auth/register_page.dart';
import 'package:reforma360/src/presentation/pages/auth/register_photo_page.dart';
import 'package:reforma360/src/presentation/pages/auth/register_professional_page.dart';
import 'package:reforma360/src/presentation/pages/auth/verify_user_page.dart';
import 'package:reforma360/src/presentation/pages/auth/change_password_page.dart';

// Importaciones de las páginas principales de la aplicación
import 'package:reforma360/src/presentation/pages/home/home_page.dart';
import 'package:reforma360/src/presentation/pages/feed/feed_page.dart';
import 'package:reforma360/src/presentation/pages/messages/messages_page.dart';
import 'package:reforma360/src/presentation/pages/messages/chat_page.dart';
import 'package:reforma360/src/presentation/pages/profile/profile_page.dart';
import 'package:reforma360/src/presentation/pages/profile/edit_profile_page.dart';
import 'package:reforma360/src/presentation/pages/post/new_post_page.dart';
import 'package:reforma360/src/presentation/pages/professionals/professionals_page.dart';
import 'package:reforma360/src/presentation/pages/professionals/processing_page.dart';

// Importación del proveedor de autenticación
import 'package:reforma360/src/presentation/providers/auth/auth_provider.dart';

// Proveedor que configura el enrutador principal de la aplicación
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Ruta inicial de la aplicación
    initialLocation: RouteNames.login,

    // Función de redirección que maneja la lógica de autenticación
    redirect: (context, state) {
      final user = ref.read(userProvider);
      final loc = state.uri.path;

      // Conjunto de rutas que requieren que el usuario NO esté autenticado
      final authRoutes = {
        RouteNames.login,
        RouteNames.register,
        RouteNames.recoverPassword,
        RouteNames.registerPhoto,
        RouteNames.registerProfessional,
      };

      // Redirige a login si el usuario no está autenticado y trata de acceder a rutas protegidas
      if (user == null && !authRoutes.contains(loc)) return RouteNames.login;
      // Redirige a home si el usuario está autenticado y trata de acceder a rutas de autenticación
      if (user != null && authRoutes.contains(loc)) return RouteNames.home;
      return null;
    },

    // Definición de todas las rutas de la aplicación
    routes: [
      // Rutas de autenticación
      GoRoute(path: RouteNames.login, builder: (_, __) => const LoginPage()),
      GoRoute(
        path: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),

      // Ruta para subir foto de perfil durante el registro
      GoRoute(
        path: RouteNames.registerPhoto,
        builder: (ctx, state) {
          final args = state.extra! as Map<String, dynamic>;
          return RegisterPhotoPage(
            userId: args['userId'] as int,
            isProfessional: args['isProfessional'] as bool,
            email: args['email'] as String,
            password: args['password'] as String,
          );
        },
      ),

      // Ruta para registro de profesionales
      GoRoute(
        path: RouteNames.registerProfessional,
        builder: (ctx, state) {
          final args = state.extra! as Map<String, dynamic>;
          return RegisterProfessionalPage(
            userId: args['userId'] as int,
            email: args['email'] as String,
            password: args['password'] as String,
          );
        },
      ),

      // Ruta para recuperación de contraseña
      GoRoute(
        path: RouteNames.recoverPassword,
        builder: (_, __) => const VerifyUserPage(),
      ),

      // Rutas principales de la aplicación
      GoRoute(path: RouteNames.home, builder: (_, __) => const HomePage()),
      GoRoute(path: RouteNames.feed, builder: (_, __) => const FeedPage()),
      // Ruta de mensajes que requiere el ID del usuario actual
      GoRoute(
        path: RouteNames.messages,
        builder:
            (ctx, state) =>
                MessagesPage(userId: ref.read(userProvider)!.id.toString()),
      ),

      // Rutas relacionadas con el perfil
      GoRoute(
        path: RouteNames.profile,
        builder: (_, __) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (_, __) => const EditProfilePage(),
      ),

      // Ruta para crear nuevos posts
      GoRoute(
        path: RouteNames.newPost,
        builder: (_, __) => const NewPostPage(),
      ),

      // Ruta para cambiar contraseña
      GoRoute(
        path: RouteNames.changePassword,
        builder: (ctx, state) {
          final email = state.extra as String? ?? '';
          return ChangePasswordPage(email: email);
        },
      ),

      // Ruta para ver profesionales
      GoRoute(
        path: RouteNames.professionals,
        builder: (ctx, state) => const ProfessionalsPage(),
      ),

      // Ruta para procesar solicitudes de profesionales
      GoRoute(
        path: RouteNames.processing,
        builder: (ctx, state) {
          final args = state.extra as Map<String, dynamic>;
          return ProcessingPage(
            professionalId: args['professionalId'] as String,
            professionalName: args['professionalName'] as String,
            categoria: args['categoria'] as String,
            userId: args['userId'] as String,
            userName: args['userName'] as String,
          );
        },
      ),

      // Ruta para el chat individual
      GoRoute(
        path: RouteNames.chat,
        builder: (ctx, state) {
          final args = state.extra as Map<String, dynamic>;
          return ChatPage(
            conversationId: args['conversationId'] as int,
            currentUserId: args['currentUserId'] as String,
          );
        },
      ),
    ],
  );
});
