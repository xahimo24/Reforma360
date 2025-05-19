import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final categoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final uri = Uri.parse('http://10.100.0.12/reforma360_api/get_categories.php');
  final resp = await http.get(uri);
  final data = jsonDecode(resp.body);
  if (data['success'] == true && data['categories'] is List) {
    return (data['categories'] as List)
        .map((e) => {
              'id': int.parse(e['id_categoria'].toString()),
              'nombre': e['nom'],
            })
        .toList();
  }
  return [];
});