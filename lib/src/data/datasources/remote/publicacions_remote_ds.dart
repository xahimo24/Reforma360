import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import '../../models/publicacio_model.dart';

class PublicacionsRemoteDataSource {
  final String baseUrl = 'http://10.100.0.12/reforma360_api';

  // Método para crear una publicación (sin title)
  Future<PublicacioModel> createPublication({
    required int userId,
    required String description,
    required File imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/upload_publication.php');
    final req = http.MultipartRequest('POST', uri);

    // Campos POST
    req.fields['user_id'] = userId.toString();
    req.fields['description'] = description;

    // Fichero de imagen
    final fileName = p.basename(imageFile.path);
    req.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: fileName,
      ),
    );

    // Enviamos
    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode != 200) {
      throw Exception('Error servidor: ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Error al crear publicación');
    }
    return PublicacioModel.fromJson(data['publication']);
  }

  // Método existente para obtener el feed completo…
  Future<List<PublicacioModel>> getPublicacions() async {
    final resp = await http.get(Uri.parse('$baseUrl/get_publicacions.php'));
    if (resp.statusCode != 200)
      throw Exception('Error servidor: ${resp.statusCode}');
    final data = jsonDecode(resp.body);
    if (data['success'] != true) throw Exception(data['message']);
    return (data['publicacions'] as List)
        .map((e) => PublicacioModel.fromJson(e))
        .toList();
  }
}
