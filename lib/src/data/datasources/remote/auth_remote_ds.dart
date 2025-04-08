import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth/user_model.dart';

class AuthRemoteDataSource {
  final String baseUrl =
      'http://localhost/reforma360_api'; // o tu IP si pruebas desde el móvil

  Future<bool> registerUser(RegisterRequest user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data['success']) {
      return true;
    } else {
      throw Exception(data['message'] ?? 'Error al registrar usuario');
    }
  }
}
