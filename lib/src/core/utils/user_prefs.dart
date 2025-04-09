import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/auth/user_model.dart';

class UserPrefs {
  static const String keyUser = 'loggedUser';

  // Guardar el usuario en formato JSON
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // Usamos toJson() en lugar de toMap()
    final userMap = user.toJson(); // Map<String, dynamic>
    final userJson = jsonEncode(userMap);
    await prefs.setString(keyUser, userJson);
  }

  // Cargar el usuario
  static Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(keyUser);
    if (userJson == null) {
      return null;
    }
    // Decodificamos JSON y usamos fromJson() en lugar de fromMap()
    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return UserModel.fromJson(userMap);
  }

  // Limpiar
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUser);
  }
}
