import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/publicacions/publicacions_provider.dart';
import '../../widgets/shared/bottom_navigator.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_names.dart';
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go(RouteNames.newPost);
            },
          ),
        ],
      ),
      body: _buildFeed(),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
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
