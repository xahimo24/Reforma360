// ─────────────────────────────────────────────────────────────────────────────
// IMPORTACIONS
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart'; // Llibreria principal de Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Gestió de l'estat amb Riverpod.
import 'package:go_router/go_router.dart'; // Navegació amb GoRouter.
import 'package:shared_preferences/shared_preferences.dart'; // Per gestionar preferències locals.
import 'package:timeago/timeago.dart'
    as timeago; // Llibreria per mostrar dates relatives.
import 'package:http/http.dart' as http; // Llibreria per fer peticions HTTP.

import '../../providers/auth/auth_provider.dart'; // Proveïdor d'autenticació.
import '../../providers/publicacions/user_publications_provider.dart'; // Proveïdor de publicacions de l'usuari.
import '../../../core/routes/route_names.dart'; // Rutes de l'aplicació.
import '../../widgets/shared/bottom_navigator.dart'; // Widget compartit per a la navegació inferior.
import '../../providers/professionals/professionals_provider.dart'; // Añade este import

// ─────────────────────────────────────────────────────────────────────────────
// WIDGET PRINCIPAL – Pàgina de perfil de l'usuari
// ─────────────────────────────────────────────────────────────────────────────
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Índex del BottomNavigator (Perfil = 4)
  int _currentIndex = 4;

  // Funció per tancar sessió: neteja l'estat i redirigeix al login.
  Future<void> _logout() async {
    ref.read(userProvider.notifier).state =
        null; // Esborra l'usuari del proveïdor.
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Esborra les preferències locals.
    context.go(RouteNames.login); // Redirigeix a la pàgina de login.
  }

  // Funció per eliminar una publicació via HTTP POST.
  Future<bool> deletePublication(int id) async {
    final url = Uri.parse(
      'http://10.100.0.12/reforma360_api/delete_publication.php', // Endpoint per eliminar publicacions.
    );
    final response = await http.post(
      url,
      body: {'id': id.toString()},
    ); // Envia la petició amb l'ID de la publicació.
    return response.statusCode == 200 &&
        response.body.contains(
          '"success":true',
        ); // Retorna true si l'eliminació és exitosa.
  }

  // Mostra un diàleg de confirmació i elimina la publicació si l'usuari accepta.
  Future<void> _confirmDelete(int pubId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Eliminar publicació'),
            content: const Text('Segur que vols eliminar aquesta publicació?'),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.pop(context, false), // Cancel·la l'acció.
                child: const Text('Cancel·lar'),
              ),
              TextButton(
                onPressed:
                    () => Navigator.pop(context, true), // Confirma l'acció.
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await deletePublication(pubId); // Elimina la publicació.
      if (success) {
        // Refresca el llistat de publicacions.
        ref.refresh(userPublicationsProvider(ref.read(userProvider)!.id));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Publicació eliminada')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en eliminar la publicació')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider); // Obté l'usuari actual.

    // Si no hi ha usuari loguejat, redirigeix automàticament.
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.login); // Redirigeix al login.
      });
      return const Scaffold(
        body: SizedBox.shrink(),
      ); // Retorna un Scaffold buit.
    }

    // URL completa de l'avatar de l'usuari.
    final avatarUrl =
        user.foto.startsWith('http')
            ? user.foto
            : 'http://10.100.0.12/reforma360_api/${user.foto}';

    // Carrega les publicacions de l'usuari.
    final postsAsync = ref.watch(userPublicationsProvider(user.id));

    return Scaffold(
      // ───── APPBAR: Títol, tornar, tancar sessió ─────
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              () => context.go(RouteNames.home), // Torna a la pàgina principal.
        ),
        title: Text(user.nom), // Mostra el nom de l'usuari.
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Tancar sessió'),
                      content: const Text('Segur que vols tancar la sessió?'),
                      actions: [
                        TextButton(
                          onPressed:
                              () => Navigator.pop(
                                context,
                                false,
                              ), // Cancel·la l'acció.
                          child: const Text('Cancel·lar'),
                        ),
                        TextButton(
                          onPressed:
                              () => Navigator.pop(
                                context,
                                true,
                              ), // Confirma l'acció.
                          child: const Text('Sortir'),
                        ),
                      ],
                    ),
              );
              if (confirm == true)
                await _logout(); // Tanca la sessió si es confirma.
            },
          ),
        ],
      ),

      // ───── COS: Perfil + publicacions ─────
      body: postsAsync.when(
        data: (posts) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemCount:
                1 +
                posts.length, // Primer element = perfil, després publicacions.
            itemBuilder: (context, idx) {
              // ───── Secció perfil ─────
              if (idx == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          avatarUrl,
                        ), // Mostra l'avatar de l'usuari.
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

                    // --- BIO EN CARD ---
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // El color del Card viene de theme.cardTheme.color automáticamente,
                      // así que no hace falta especificarlo aquí.
                      elevation: Theme.of(context).cardTheme.elevation ?? 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 22,
                                  // Usamos el primary del esquema de color para el icono
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Bio',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    // color de texto del título viene de onSurface
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              user.bio ?? 'Usuari de Reforma 360',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                // color de cuerpo de texto
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // --- FIN BIO EN CARD ---

                    if (user.tipus) ...[
                      Consumer(
                        builder: (context, ref, _) {
                          final profsAsync = ref.watch(professionalsProvider(''));
                          return profsAsync.when(
                            data: (profs) {
                              final profsList = profs.where((p) => p.userId == user.id).toList();
                              if (profsList.isEmpty) {
                                return const Text('No tienes perfil profesional.');
                              }
                              final prof = profsList.first;
                                return Card(
                                ///color: Colors.blueGrey[50],
                                margin: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                    children: const [
                                      Icon(Icons.work, size: 22),
                                      SizedBox(width: 8),
                                      Text(
                                      'Datos profesionales',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        ///color: Colors.black,
                                      ),
                                      ),
                                    ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                    children: [
                                      const Icon(Icons.category, size: 18),
                                      const SizedBox(width: 6),
                                      Text('Categoría: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text(prof.categoryName),
                                    ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                    children: [
                                      const Icon(Icons.timeline, size: 18),
                                      const SizedBox(width: 6),
                                      Text('Experiencia: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text('${prof.experience} años'),
                                    ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                    children: [
                                      const Icon(Icons.location_city, size: 18),
                                      const SizedBox(width: 6),
                                      Text('Ciudad: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text(prof.city),
                                    ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.description, size: 18),
                                      const SizedBox(width: 6),
                                      Text('Descripción: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Expanded(child: Text(prof.description)),
                                    ],
                                    ),
                                  ],
                                  ),
                                ),
                                );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (e, _) => Text('Error: $e'),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed:
                            () => context.push(
                              RouteNames.editProfile,
                            ), // Navega a la pàgina d'edició de perfil.
                        child: const Text('Editar perfil'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }

              // ───── Secció publicacions ─────
              final pub = posts[idx - 1];
              final imageUrl =
                  'http://10.100.0.12/reforma360_api/${pub.contingut}'; // URL de la imatge de la publicació.

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
                      // Capçalera amb avatar + data + menú.
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
                                timeago.format(
                                  pub.dataPublicacio,
                                ), // Mostra la data relativa.
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Menú de 3 punts: Eliminar publicació.
                          PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'delete')
                                _confirmDelete(
                                  pub.id,
                                ); // Elimina la publicació si es selecciona.
                            },
                            itemBuilder:
                                (_) => const [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Eliminar publicació'),
                                  ),
                                ],
                            child: const Icon(Icons.more_horiz),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Imatge de la publicació.
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder:
                              (_, __, ___) => const Text(
                                'Imatge no disponible',
                              ), // Mostra un missatge si la imatge no es carrega.
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Descripció de la publicació.
                      Text(pub.descripcio),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(),
            ), // Mostra un indicador de càrrega.
        error:
            (e, _) => Center(
              child: Text('Error en carregar publicacions: $e'),
            ), // Mostra un error si falla.
      ),

      // ───── NAVEGACIÓ INFERIOR ─────
      bottomNavigationBar: BottomNavigation(
        currentIndex: 4, // Índex actual (Perfil).
        userAvatarUrl: avatarUrl, // Passa la URL de l'avatar.
      ),
    );
  }
}
