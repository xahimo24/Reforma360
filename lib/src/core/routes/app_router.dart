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
import 'package:reforma360/src/presentation/pages/notification/notification_page.dart';
import 'package:reforma360/src/presentation/pages/messages/messages_menu_page.dart';
import 'package:reforma360/src/presentation/pages/profile/profile_page.dart';
import 'package:reforma360/src/presentation/pages/profile/edit_profile_page.dart';
import 'package:reforma360/src/presentation/pages/post/new_post_page.dart';
import 'package:reforma360/src/presentation/providers/auth/auth_provider.dart';
import 'package:reforma360/src/presentation/pages/professionals/professionals_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.login,
    redirect: (context, state) {
      final user = ref.read(userProvider);
      final loc = state.uri.path;
      final authRoutes = {
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
      GoRoute(path: RouteNames.login, builder: (_, __) => const LoginPage()),
      GoRoute(
        path: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),
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
      GoRoute(
        path: RouteNames.recoverPassword,
        builder: (_, __) => const VerifyUserPage(),
      ),
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
      GoRoute(
        path: RouteNames.editProfile,
        builder: (_, __) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteNames.newPost,
        builder: (_, __) => const NewPostPage(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        builder: (context, state) {
          // Recogemos el email que pasamos como extra desde EditProfilePage
          final email = state.extra as String? ?? '';
          return ChangePasswordPage(email: email);
        },
      ),
      GoRoute(
        path: RouteNames.professionals,
        builder: (context, state) => const ProfessionalsPage(),
      ),
    ],
  );
});
