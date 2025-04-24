// ─────────────────────────────────────────────────────────────────────────────
// IMPORTACIONES
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

import '../../providers/auth/auth_provider.dart';
import '../../providers/publicacions/user_publications_provider.dart';
import '../../../core/routes/route_names.dart';
import '../../widgets/shared/bottom_navigator.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WIDGET PRINCIPAL – Página de perfil del usuario
// ─────────────────────────────────────────────────────────────────────────────
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Índice del BottomNavigator (Perfil = 4)
  int _currentIndex = 4;

  // Cerrar sesión: limpia el estado y redirige al login
  Future<void> _logout() async {
    ref.read(userProvider.notifier).state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    context.go(RouteNames.login);
  }

  // Función para eliminar una publicación vía HTTP POST
  Future<bool> deletePublication(int id) async {
    final url = Uri.parse(
      'http://10.100.0.12/reforma360_api/delete_publication.php',
    );
    final response = await http.post(url, body: {'id': id.toString()});
    return response.statusCode == 200 &&
        response.body.contains('"success":true');
  }

  // Muestra confirmación y elimina publicación si el usuario acepta
  Future<void> _confirmDelete(int pubId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Eliminar publicación'),
            content: const Text(
              '¿Seguro que quieres eliminar esta publicación?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await deletePublication(pubId);
      if (success) {
        // Refresca el listado del provider
        ref.refresh(userPublicationsProvider(ref.read(userProvider)!.id));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Publicación eliminada')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar publicación')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    // Si no hay usuario logueado, redirige automáticamente
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.login);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    // URL completa del avatar
    final avatarUrl =
        user.foto.startsWith('http')
            ? user.foto
            : 'http://10.100.0.12/reforma360_api/${user.foto}';

    // Carga de publicaciones del usuario
    final postsAsync = ref.watch(userPublicationsProvider(user.id));

    return Scaffold(
      // ───── APPBAR: Título, volver, cerrar sesión ─────
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.home),
        ),
        title: Text(user.nom),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Cerrar sesión'),
                      content: const Text('¿Seguro que quieres cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Salir'),
                        ),
                      ],
                    ),
              );
              if (confirm == true) await _logout();
            },
          ),
        ],
      ),

      // ───── CUERPO: Perfil + publicaciones ─────
      body: postsAsync.when(
        data: (posts) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemCount:
                1 + posts.length, // Primer item = perfil, luego publicaciones
            itemBuilder: (context, idx) {
              // ───── Sección perfil ─────
              if (idx == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(avatarUrl),
                        radius: 60,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      user.nom,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.cognoms,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bio:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.bio ?? 'Usuario de Reforma 360',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => context.push(RouteNames.editProfile),
                        child: const Text(
                          'Editar perfil',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }

              // ───── Sección publicaciones ─────
              final pub = posts[idx - 1];
              final imageUrl =
                  'http://10.100.0.12/reforma360_api/${pub.contingut}';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabecera con avatar + fecha + botón menú
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(avatarUrl),
                            radius: 18,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user.nom} ${user.cognoms}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                timeago.format(pub.dataPublicacio),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Menú de 3 puntos: Eliminar publicación
                          PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'delete') _confirmDelete(pub.id);
                            },
                            itemBuilder:
                                (_) => const [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Eliminar publicación'),
                                  ),
                                ],
                            child: const Icon(Icons.more_horiz),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Imagen de la publicación
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder:
                              (_, __, ___) =>
                                  const Text('Imagen no disponible'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Descripción del post
                      Text(pub.descripcio),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(child: Text('Error al cargar publicaciones: $e')),
      ),

      // ───── NAV INFERIOR ─────
      bottomNavigationBar: const BottomNavigation(currentIndex: 4),
    );
  }
}
