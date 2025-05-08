// File: lib/src/presentation/providers/professionals/professionals_provider.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:reforma360/src/data/models/professional_model.dart';

/// Provider que carga la lista de profesionales desde la API.
///
/// - [family] permite pasar una ciudad para filtrar (cadena vacía = todas).
/// - Devuelve una lista de [ProfessionalModel].
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

  // 4) Convertir cada item al modelo
  final items =
      (body['professionals'] as List<dynamic>)
          .map(
            (json) => ProfessionalModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

  return items;
});
