import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/auth/user_model.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/publicacions/user_publications_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No hay usuario logueado')),
      );
    }

    // Cargamos publicaciones del usuario
    final userPubsAsync = ref.watch(userPublicationsProvider(user.id));

    return Scaffold(
      // APP BAR estilo: + a la izquierda, nombre en medio, logout a la derecha
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            // Aquí lo que quieras hacer con el "+" (nueva publicación, etc.)
          },
        ),
        centerTitle: true,
        title: Text('${user.nom}'), // Nombre en el centro
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmar cierre de sesión'),
                    content: const Text(
                      '¿Estás seguro de que quieres cerrar sesión?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Cancelar
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Confirmar
                        },
                        child: const Text('Cerrar sesión'),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                // Cerrar sesión
                ref.read(userProvider.notifier).state = null;
                await _clearPrefs();

                // Redirigir a la página de login
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FOTO AVATAR (centrada)
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  user.foto.isNotEmpty ? NetworkImage(user.foto) : null,
              child:
                  user.foto.isEmpty ? const Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 16),

            // Nombre + Apellido (o lo que tú quieras)
            Text(
              user.nom,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Apellidos
            Text(
              user.cognoms,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),

            const SizedBox(height: 8),

            // BIO
            const Text('Bio:', style: TextStyle(fontWeight: FontWeight.bold)),
            // Si de momento no guardas la bio en BBDD, pongo un placeholder
            const Text('Usuario de Reforma 360'),

            const SizedBox(height: 16),

            // Botón Editar perfil
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navegar a la pantalla de edición de perfil
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Editar perfil',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // PUBLICACIONES DEL USUARIO
            // Título (opcional)
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'Publicaciones',
            //     style: Theme.of(context).textTheme.titleMedium,
            //   ),
            // ),
            // const SizedBox(height: 8),

            // FutureBuilder con Riverpod
            userPubsAsync.when(
              data: (publicaciones) {
                if (publicaciones.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Aún no tienes nada publicado",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  // Usamos shrinkWrap para que no dé error al estar en SingleChildScrollView
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: publicaciones.length,
                  itemBuilder: (context, index) {
                    final pub = publicaciones[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(pub.descripcio),
                        subtitle: Text(pub.contingut),
                      ),
                    );
                  },
                );
              },
              loading:
                  () => const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CircularProgressIndicator(),
                  ),
              error:
                  (err, st) => Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: $err'),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
