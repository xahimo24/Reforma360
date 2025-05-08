// lib/src/presentation/pages/professionals/professionals_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routes/route_names.dart';
import '../../providers/professionals/professionals_provider.dart';
import '../../data/models/professional_detail_model.dart';
import '../../widgets/shared/bottom_navigator.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:reforma360/src/presentation/pages/professionals/processing_page.dart';
// 👇 1. IMPORT — usa SIEMPRE la ruta package: para evitar el error /*1*/ vs /*2*/
import 'package:reforma360/src/data/models/professional_model.dart';

/// Pantalla para buscar y listar profesionales
class ProfessionalsPage extends ConsumerStatefulWidget {
  const ProfessionalsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfessionalsPage> createState() => _ProfessionalsPageState();
}

class _ProfessionalsPageState extends ConsumerState<ProfessionalsPage> {
  String _searchTerm = '';
  String _selectedCity = '';
  String _sortOption = 'Rating';

  @override
  Widget build(BuildContext context) {
    final profsAsync = ref.watch(professionalsProvider(_selectedCity));
    final user = ref.watch(userProvider);
    final avatarUrl =
        user != null
            ? user.foto.startsWith('http')
                ? user.foto
                : 'http://10.100.0.12/reforma360_api/${user.foto}'
            : null;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Busca profesionales…',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _searchTerm = v),
        ),
        elevation: 0,
      ),

      body: Column(
        children: [
          // Filtros:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedCity.isEmpty ? null : _selectedCity,
                  hint: const Text('Filter'),
                  items:
                      <String>['', 'Barcelona', 'Madrid', 'Valencia']
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.isEmpty ? 'Todas' : c),
                            ),
                          )
                          .toList(),
                  onChanged: (c) => setState(() => _selectedCity = c ?? ''),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _sortOption,
                  items:
                      const ['Rating', 'Experience']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                  onChanged: (s) => setState(() => _sortOption = s!),
                ),
                const Spacer(),
                Text('${profsAsync.asData?.value.length ?? 0} results'),
              ],
            ),
          ),

          // Lista:
          Expanded(
            child: profsAsync.when(
              data: (list) {
                final term = _searchTerm.toLowerCase();
                final filtered =
                    list.where((p) {
                      return p.userName.toLowerCase().contains(term) ||
                          p.category.toLowerCase().contains(term);
                    }).toList();

                if (_sortOption == 'Experience') {
                  filtered.sort((a, b) => b.experience.compareTo(a.experience));
                } else {
                  filtered.sort((a, b) => b.avgRating.compareTo(a.avgRating));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    final imageUrl =
                        'http://10.100.0.12/reforma360_api/${p.userAvatar}';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen clicable para abrir modal de detalle:
                        InkWell(
                          onTap: () => _showDetailModal(context, p),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 48),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Nombre + Categoría
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.userName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    p.category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Rating / reviews / ciudad
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                Text(p.avgRating.toStringAsFixed(1)),
                                const SizedBox(width: 4),
                                Text('(${p.reviewsCount} reviews)'),
                                const SizedBox(width: 8),
                                Text(p.city),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Descripción breve
                        Text(
                          p.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Botón Select (sin tocar)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProcessingPage(
                                          professionalName: p.userName,
                                        ),
                                  ),
                                ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text('Select'),
                          ),
                        ),

                        const Divider(height: 32),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigation(
        currentIndex: 1,
        userAvatarUrl: avatarUrl,
      ),
    );
  }

  /// Muestra un modal con TODOS los datos del profesional
  void _showDetailModal(BuildContext context, ProfessionalModel p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      // 🆕 2. Envuelve el contenido en SingleChildScrollView para evitar overflow
      builder:
          (_) => SingleChildScrollView(
            padding: EdgeInsets.only(
              // respeta el teclado si aparece
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Arrastrador
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Cabecera
                Text(
                  p.userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  p.category,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // Imagen grande
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    // Si la API ya devuelve URL absoluta, quita el prefijo
                    p.userAvatar.startsWith('http')
                        ? p.userAvatar
                        : 'http://10.100.0.12/reforma360_api/${p.userAvatar}',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 48),
                  ),
                ),
                const SizedBox(height: 16),

                // Descripción
                Text(p.description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),

                // Otros datos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Experiencia: ${p.experience} años'),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(p.avgRating.toStringAsFixed(1)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Ciudad: ${p.city}'),
                const SizedBox(height: 24),

                // Botón cerrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
