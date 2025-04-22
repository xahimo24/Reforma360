import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/auth/user_model.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/publicacions/user_publications_provider.dart';
import '../../../core/routes/route_names.dart';
import '../profile/edit_profile_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Índice 4 = Perfil
  int _currentIndex = 4;

  Future<void> _logout() async {
    // 1) Limpiar provider y prefs
    ref.read(userProvider.notifier).state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // 2) Ir a login
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    // Si no hay usuario, redirigimos inmediatamente
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.login);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final pubsAsync = ref.watch(userPublicationsProvider(user.id));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.home),
        ),
        centerTitle: true,
        title: Text(user.nom),
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // Avatar centrado
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    user.foto.isNotEmpty ? NetworkImage(user.foto) : null,
                child:
                    user.foto.isEmpty
                        ? const Icon(Icons.person, size: 50)
                        : null,
              ),
            ),
            const SizedBox(height: 16),

            // Campos de datos (bloqueados)
            _buildField(user.nom),
            const SizedBox(height: 12),
            _buildField(user.cognoms),
            const SizedBox(height: 12),
            _buildField(user.telefon),
            const SizedBox(height: 12),
            _buildField(user.email),
            const SizedBox(height: 24),

            // Botón Editar perfil
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navegar a EditProfilePage pasándole un Map con los campos
                  context.push(
                    RouteNames.editProfile,
                    extra: {
                      'nombre': user.nom,
                      'apellidos': user.cognoms,
                      'telefono': user.telefon,
                      'email': user.email,
                    },
                  );
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
            const SizedBox(height: 24),

            // Publicaciones
            pubsAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return const Text('Aún no tienes nada publicado');
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final pub = list[i];
                    return Card(
                      child: ListTile(
                        title: Text(pub.descripcio),
                        subtitle: Text(pub.contingut),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error al cargar publicaciones: $e'),
            ),
          ],
        ),
      ),

      // BottomNavigationBar visible
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          switch (i) {
            case 0:
              context.go(RouteNames.home);
              break;
            case 1:
              context.go(RouteNames.search);
              break;
            case 2:
              context.go(RouteNames.notifications);
              break;
            case 3:
              context.go(RouteNames.messages);
              break;
            case 4:
              context.go(RouteNames.profile);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Avisos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mensajes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  // Campo de solo lectura
  Widget _buildField(String value) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
