// lib/src/core/routes/route_names.dart

/// Clase que centraliza todos los nombres de ruta de la aplicación.
/// 🛑 A partir de ahora, TODAS las rutas deben estar aquí definidas
/// para evitar referencias a constantes inexistentes.
class RouteNames {
  // ─── Auth ───
  /// Pantalla de login
  static const login = '/login';

  /// Pantalla de registro
  static const register = '/register';

  /// Pantalla de recuperación de contraseña (olvidada)
  static const recoverPassword = '/recover-password';

  /// Pantalla de cambiar contraseña (usuario logueado)
  static const changePassword = '/change-password';

  // ─── Registro multi-step ───
  /// Paso de foto en el registro
  static const registerPhoto = '/register-photo';

  /// Paso de profesional en el registro
  static const registerProfessional = '/register-professional';

  // ─── Main ───
  /// Pantalla principal / feed
  static const home = '/';

  /// Feed genérico (si lo usas aparte)
  static const feed = '/feed';

  /// Pantalla de profesionales
  static const professionals = '/professionals';

  /// Notificaciones
  static const notifications = '/notifications';

  /// Mensajes privados
  static const messages = '/messages';

  /// Perfil del usuario
  static const profile = '/profile';

  /// Pantalla de edición de perfil
  static const editProfile = '/edit_profile';

  /// Pantalla de nueva publicación
  static const newPost = '/new-post';
}
