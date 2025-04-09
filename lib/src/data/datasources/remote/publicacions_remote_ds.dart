import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/publicacio_model.dart';

class PublicacionsRemoteDataSource {
  final String baseUrl = 'http://localhost/reforma360_api';

  Future<List<PublicacioModel>> getPublicacions() async {
    final response = await http.get(Uri.parse('$baseUrl/get_publicacions.php'));

    final data = jsonDecode(response.body);

    if (data['success']) {
      final List<dynamic> list = data['publicacions'];
      return list.map((json) => PublicacioModel.fromJson(json)).toList();
    } else {
      throw Exception(data['message'] ?? 'Error al obtener publicaciones');
    }
  }
}
