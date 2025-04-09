import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/publicacions/publicacions_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildFeed(),
      const Center(child: Text("Buscar")),
      const Center(child: Text("Notificaciones")),
      const Center(child: Text("Mensajes")),
      const Center(child: Text("Perfil")),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Reforma360")),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notificaciones",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Mensajes"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    // Consumimos el publicacionsProvider
    final publicacionsAsync = ref.watch(publicacionsProvider);

    return publicacionsAsync.when(
      data: (publicacions) {
        if (publicacions.isEmpty) {
          return const Center(child: Text("No hay publicaciones todavía."));
        }
        return ListView.builder(
          itemCount: publicacions.length,
          itemBuilder: (context, index) {
            final pub = publicacions[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(pub.descripcio),
                subtitle: Text(pub.contingut),
                // Podrías mostrar la fecha formateada
                // trailing: Text(pub.dataPublicacio.toLocal().toString()),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
