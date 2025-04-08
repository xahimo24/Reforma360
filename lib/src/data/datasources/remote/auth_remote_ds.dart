import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth/user_model.dart';
import '../../models/auth/register_request.dart';

class AuthRemoteDataSource {
  final String baseUrl = 'http://localhost/reforma360_api';

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

  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (data['success']) {
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Error al iniciar sesión');
    }
  }
}
