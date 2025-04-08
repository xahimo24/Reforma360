import 'package:go_router/go_router.dart';
import 'package:reforma360/src/presentation/pages/auth/login_page.dart';
import 'package:reforma360/src/presentation/pages/auth/register_page.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
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
  ],
);
