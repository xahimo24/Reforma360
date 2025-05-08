// File: lib/src/presentation/providers/professionals/professionals_provider.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:reforma360/src/data/models/professional_model.dart';

/// Provider que carga la lista de profesionales desde la API.
///
/// - [family] permite pasar una ciudad para filtrar (cadena vacía = todas).
/// - Devuelve una lista de [ProfessionalModel].
///
/// Notas sobre JSON:
/// La API debe devolver para cada profesional:
/// {
///   "id": int,
///   "id_usuari": int,
///   "user_name": string,
///   "user_avatar": string,
///   "category_id": int|null,
///   "category_name": string|null,
///   "experiencia": int,
///   "descripcio": string,
///   "ciudad": string,
///   "avg_rating": double,
///   "reviews_count": int
/// }

final professionalsProvider = FutureProvider.family<
  List<ProfessionalModel>,
  String
>((ref, ciudadFiltro) async {
  // 1) Construir URI con parámetro opcional ?ciudad=
  final uri = Uri.parse(
    'http://10.100.0.12/reforma360_api/get_professionals.php' +
        (ciudadFiltro.isNotEmpty ? '?ciudad=$ciudadFiltro' : ''),
  );

  // 2) Petición HTTP GET
  final response = await http.get(uri);
  if (response.statusCode != 200) {
    throw Exception('Error HTTP ${response.statusCode}');
  }

  // 3) Parsear JSON
  final body = jsonDecode(response.body) as Map<String, dynamic>;
  if (body['success'] != true) {
    throw Exception('API error: ${body['message']}');
  }

  // 4) Convertir cada item al modelo, pasando category_id y category_name
  final items =
      (body['professionals'] as List<dynamic>)
          .map(
            (json) => ProfessionalModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

  return items;
});
