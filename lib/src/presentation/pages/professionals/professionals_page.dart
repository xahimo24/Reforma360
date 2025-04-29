// lib/src/presentation/pages/professionals/professionals_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../providers/professionals/professionals_provider.dart';
import '../../data/models/professional_model.dart';
import '../../widgets/shared/bottom_navigator.dart';
import '../../providers/auth/auth_provider.dart';

/// Pantalla para buscar y listar profesionales
class ProfessionalsPage extends ConsumerStatefulWidget {
  const ProfessionalsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfessionalsPage> createState() => _ProfessionalsPageState();
}

class _ProfessionalsPageState extends ConsumerState<ProfessionalsPage> {
  String _searchTerm = ''; // Texto de búsqueda
  String _selectedCity = ''; // Filtro ciudad
  String _sortOption = 'Rating'; // Opción de ordenación

  @override
  Widget build(BuildContext context) {
    // Observamos el provider con el filtro de ciudad
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
            suffixIcon: Icon(Icons.edit), // icono lápiz
          ),
          onChanged: (v) => setState(() => _searchTerm = v),
        ),
        elevation: 0,
      ),

      body: Column(
        children: [
          // --- Filtros: Ciudad y Ordenación ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Dropdown ciudades (puedes ampliar la lista)
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
                // Dropdown sort
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

          // --- Lista de profesionales ---
          Expanded(
            child: profsAsync.when(
              data: (list) {
                // Filtrar localmente por búsqueda
                final filtered =
                    list
                        .where(
                          (p) => p.userName.toLowerCase().contains(
                            _searchTerm.toLowerCase(),
                          ),
                        )
                        .toList();

                // Ordenar localmente
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
                    // URL completa de la foto
                    final avatarUrl =
                        'http://10.100.0.12/reforma360_api/${p.userAvatar}';
                    return Column(
                      children: [
                        // Imagen de portada
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            avatarUrl,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 48),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Nombre y rating / reviews / distancia
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                p.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                Text('${p.city}'),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        // Botón negro "Select"
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            onPressed:
                                () => context.go(
                                  RouteNames.profile /*más adelante detalle*/,
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
        currentIndex: 2,
        userAvatarUrl: avatarUrl,
      ),
    );
  }
}
