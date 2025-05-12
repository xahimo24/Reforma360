// file: lib/src/core/routes/route_names.dart

/// Clase que centraliza todos los nombres de ruta de la aplicación.
/// A partir de ahora, TODAS las rutas deben estar aquí definidas.
class RouteNames {
  // Auth
  static const login = '/login';
  static const register = '/register';
  static const recoverPassword = '/recover-password';
  static const changePassword = '/change-password';

  // Registro multi-step
  static const registerPhoto = '/register-photo';
  static const registerProfessional = '/register-professional';

  // Main
  static const home = '/';
  static const feed = '/feed';
  static const professionals = '/professionals';
  static const notifications = '/notifications';
  static const messages = '/messages';
  static const profile = '/profile';
  static const editProfile = '/edit_profile';
  static const newPost = '/new-post';

  // Nuevas rutas para mensajería
  static const processing = '/processing';
  static const chat = '/chat';
}
