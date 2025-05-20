// file: lib/src/core/routes/app_router.dart 

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

import 'package:reforma360/src/presentation/pages/auth/login_page.dart';
import 'package:reforma360/src/presentation/pages/auth/register_page.dart';
import 'package:reforma360/src/presentation/pages/auth/register_photo_page.dart';
import 'package:reforma360/src/presentation/pages/auth/register_professional_page.dart';
import 'package:reforma360/src/presentation/pages/auth/verify_user_page.dart';
import 'package:reforma360/src/presentation/pages/auth/change_password_page.dart';

import 'package:reforma360/src/presentation/pages/home/home_page.dart';
import 'package:reforma360/src/presentation/pages/feed/feed_page.dart';

// Alias para evitar conflictos
import 'package:reforma360/src/presentation/pages/messages/messages_page.dart' as messages;
import 'package:reforma360/src/presentation/pages/messages/chat_page.dart'     as chat;

import 'package:reforma360/src/presentation/pages/profile/profile_page.dart';
import 'package:reforma360/src/presentation/pages/profile/edit_profile_page.dart';
import 'package:reforma360/src/presentation/pages/post/new_post_page.dart';
import 'package:reforma360/src/presentation/pages/professionals/professionals_page.dart';
import 'package:reforma360/src/presentation/pages/professionals/processing_page.dart';

import 'package:reforma360/src/presentation/providers/auth/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.login,

    redirect: (context, state) {
      final user = ref.read(userProvider);
      final loc  = state.uri.path;
      const authRoutes = {
        RouteNames.login,
        RouteNames.register,
        RouteNames.recoverPassword,
        RouteNames.registerPhoto,
        RouteNames.registerProfessional,
      };
      if (user == null && !authRoutes.contains(loc)) return RouteNames.login;
      if (user != null && authRoutes.contains(loc)) return RouteNames.home;
      return null;
    },

    routes: [
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.registerPhoto,
        name: RouteNames.registerPhoto,
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
      GoRoute(
        path: RouteNames.registerProfessional,
        name: RouteNames.registerProfessional,
        builder: (ctx, state) {
          final args = state.extra! as Map<String, dynamic>;
          return RegisterProfessionalPage(
            userId: args['userId'] as int,
            email: args['email'] as String,
            password: args['password'] as String,
          );
        },
      ),
      GoRoute(
        path: RouteNames.recoverPassword,
        name: RouteNames.recoverPassword,
        builder: (_, __) => const VerifyUserPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.feed,
        name: RouteNames.feed,
        builder: (_, __) => const FeedPage(),
      ),

      // *** Lista de conversaciones ***
      GoRoute(
        path: RouteNames.messages,
        name: RouteNames.messages,
        builder: (ctx, state) {
          final userId = ref.read(userProvider)!.id.toString();
          return messages.MessagesPage(userId: userId);
        },
      ),

      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        builder: (_, __) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.editProfile,
        builder: (_, __) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteNames.newPost,
        name: RouteNames.newPost,
        builder: (_, __) => const NewPostPage(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        name: RouteNames.changePassword,
        builder: (ctx, state) {
          final email = state.extra as String? ?? '';
          return ChangePasswordPage(email: email);
        },
      ),
      GoRoute(
        path: RouteNames.professionals,
        name: RouteNames.professionals,
        builder: (_, __) => const ProfessionalsPage(),
      ),
      GoRoute(
        path: RouteNames.processing,
        name: RouteNames.processing,
        builder: (ctx, state) {
          final args = state.extra as Map<String, dynamic>;
          return ProcessingPage(
            professionalId:   args['professionalId'] as String,
            professionalName: args['professionalName'] as String,
            categoria:        args['categoria'] as String,
            userId:           args['userId'] as String,
            userName:         args['userName'] as String,
          );
        },
      ),

      // *** Chat con el profesional ***
      GoRoute(
        path: '${RouteNames.chat}/:conversationId',
        name: RouteNames.chat,
        builder: (ctx, state) {
          final currentUserId = ref.read(userProvider)!.id.toString();
          final args = state.extra as Map<String, dynamic>? ?? {};
          final professionalId        = args['professionalId']       as String? ?? '';
          final professionalName      = args['professionalName']     as String? ?? 'Desconocido';
          final professionalAvatarUrl = args['professionalAvatarUrl']as String? ?? '';

          return chat.ChatPage(
            currentUserId:          currentUserId,
            professionalId:         professionalId,
            professionalName:       professionalName,
            professionalAvatarUrl:  professionalAvatarUrl,
          );
        },
      ),
    ],
  );
});
