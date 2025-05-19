// File: lib/src/presentation/pages/professionals/professionals_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reforma360/src/core/routes/route_names.dart';
import 'package:reforma360/src/presentation/providers/professionals/professionals_provider.dart';
import 'package:reforma360/src/data/models/professional_model.dart';
import 'package:reforma360/src/presentation/widgets/shared/bottom_navigator.dart';
import 'package:reforma360/src/presentation/providers/auth/auth_provider.dart';
import 'package:reforma360/src/presentation/pages/professionals/processing_page.dart';

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
            ? (user.foto.startsWith('http')
                ? user.foto
                : 'http://10.100.0.12/reforma360_api/${user.foto}')
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
          // ── Filtros ────────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedCity.isEmpty ? null : _selectedCity,
                  hint: const Text('Filter'),
                  items:
                      <String>[
                            '', // String vacío al inicio (como en tu ejemplo)
                            'Álava', // Vitoria (oficialmente Vitoria-Gasteiz)
                            'Albacete',
                            'Alicante',
                            'Almería',
                            'Asturias', // Oviedo (aunque el nombre oficial es "Principado de Asturias")
                            'Ávila',
                            'Badajoz',
                            'Barcelona',
                            'Burgos',
                            'Cáceres',
                            'Cádiz',
                            'Cantabria', // Santander (oficialmente "Cantabria", no es provincia pero su capital es Santander)
                            'Castellón', // Castellón de la Plana
                            'Ciudad Real',
                            'Córdoba',
                            'Cuenca',
                            'Gerona', // Girona (en catalán)
                            'Granada',
                            'Guadalajara',
                            'Guipúzcoa', // San Sebastián (oficialmente Donostia-San Sebastián)
                            'Huelva',
                            'Huesca',
                            'Islas Baleares', // Palma de Mallorca
                            'Jaén',
                            'La Coruña', // A Coruña (nombre oficial en gallego)
                            'La Rioja', // Logroño (oficialmente "La Rioja")
                            'Las Palmas', // Las Palmas de Gran Canaria
                            'León',
                            'Lérida', // Lleida (en catalán)
                            'Lugo',
                            'Madrid',
                            'Málaga',
                            'Murcia',
                            'Navarra', // Pamplona (oficialmente "Navarra" o "Comunidad Foral de Navarra")
                            'Orense', // Ourense (en gallego)
                            'Palencia',
                            'Pontevedra',
                            'Salamanca',
                            'Santa Cruz de Tenerife',
                            'Segovia',
                            'Sevilla',
                            'Soria',
                            'Tarragona',
                            'Teruel',
                            'Toledo',
                            'Valencia',
                            'Valladolid',
                            'Vizcaya', // Bilbao (oficialmente "Bizkaia")
                            'Zamora',
                            'Zaragoza',
                            'Ceuta',
                            'Melilla',
                          ]
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

          // ── Lista ──────────────────────────────────────────────────────────────
          Expanded(
            child: profsAsync.when(
              data: (list) {
                final term = _searchTerm.toLowerCase();
                // Filtrar por nombre o categoría
                final filtered =
                    list.where((p) {
                      return p.userName.toLowerCase().contains(term) ||
                          p.categoryName.toLowerCase().contains(term);
                    }).toList();

                // Ordenar
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
                        // Imagen clicable
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
                                    p.categoryName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

                        // Botón Select
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            onPressed: () {
                              final user = ref.read(userProvider);
                              if (user == null) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ProcessingPage(
                                        professionalId:
                                            p.userId
                                                .toString(), // ← NUEVO: id de `usuaris`
                                        professionalName: p.userName,
                                        categoria: p.categoryName,
                                        userId: user.id.toString(),
                                        userName: '${user.nom} ${user.cognoms}',
                                      ),
                                ),
                              );
                            },
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

  /// Modal con TODOS los datos del profesional
  void _showDetailModal(BuildContext context, ProfessionalModel p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  p.userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  p.categoryName,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
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

                Text(p.description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),

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
