import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; // para logout
import '../../../data/models/auth/user_model.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/publicacions/user_publications_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    // Si no hay usuario, podríamos redirigir a login o mostrar un mensaje
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No hay usuario logueado')),
      );
    }

    // Cargamos las publicaciones del usuario
    final userPubsAsync = ref.watch(userPublicationsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.nom}'), // Muestra el nombre del usuario
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // 1) Quitamos el usuario del provider
              ref.read(userProvider.notifier).state = null;
              // 2) Limpiamos SharedPreferences
              await _clearPrefs();
              // 3) Navegamos a lo que sea tu ruta de login
              Navigator.pop(
                context,
              ); // O si usas GoRouter: context.go('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Encabezado con foto y datos
          _buildHeader(user),
          // Publicaciones del usuario
          Expanded(
            child: userPubsAsync.when(
              data: (publicaciones) {
                if (publicaciones.isEmpty) {
                  return const Center(
                    child: Text("No hay publicaciones todavía"),
                  );
                }
                return ListView.builder(
                  itemCount: publicaciones.length,
                  itemBuilder: (context, index) {
                    final pub = publicaciones[index];
                    return ListTile(
                      title: Text(pub.descripcio),
                      subtitle: Text(pub.contingut),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí irás a la página de edición de perfil
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildHeader(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Foto circular
          CircleAvatar(
            radius: 40,
            backgroundImage:
                user.foto.isNotEmpty
                    ? NetworkImage(user.foto)
                    : null, // si no tienes foto, pon un placeholder
            child:
                user.foto.isEmpty ? const Icon(Icons.person, size: 40) : null,
          ),
          const SizedBox(width: 16),
          // Nombres, bio, etc.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.nom} ${user.cognoms}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Bio: Usuario de Reforma360', // Cambia si tienes un campo `bio`
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // Si quieres solo borrar al usuario:
    // prefs.remove('userId');
    // prefs.remove('nom');
    // ...
    // Sino, limpias todo:
    await prefs.clear();
  }
}
