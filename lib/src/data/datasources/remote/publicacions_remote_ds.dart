import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/publicacio_model.dart';

class PublicacionsRemoteDataSource {
  final String baseUrl = 'http://localhost/reforma360_api';

  /// Trae todas las publicaciones (get_publicacions.php)
  Future<List<PublicacioModel>> getPublicacions() async {
    final response = await http.get(Uri.parse('$baseUrl/get_publicacions.php'));
    if (response.statusCode != 200) {
      throw Exception('Error al conectar con el servidor');
    }

    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      final List<dynamic> list = data['publicacions'];
      return list.map((json) => PublicacioModel.fromJson(json)).toList();
    } else {
      throw Exception(data['message'] ?? 'Error al obtener publicaciones');
    }
  }

  /// Trae las publicaciones de un usuario (get_publications_by_user.php?id_usuari=X)
  Future<List<PublicacioModel>> getPublicacionesByUser(int userId) async {
    final uri = Uri.parse(
      '$baseUrl/get_publications_by_user.php?id_usuari=$userId',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error al conectar con el servidor (status: ${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      final List<dynamic> list = data['publicacions'];
      return list.map((json) => PublicacioModel.fromJson(json)).toList();
    } else {
      throw Exception(
        data['message'] ?? 'Error al obtener publicaciones del usuario',
      );
    }
  }
}
