import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../providers/publicacions/publicacions_provider.dart';
import '../../../core/routes/route_names.dart';
import '../../widgets/shared/bottom_navigator.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(publicacionsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.go(RouteNames.newPost),
        ),
        title: const Text('Reforma360'),
        centerTitle: true,
      ),
      body: feedAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text("No hay publicaciones todavía."));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: posts.length,
            itemBuilder: (context, i) {
              final pub = posts[i];
              final imageUrl =
                  'http://10.100.0.12/reforma360_api/${pub.contingut}';
              final avatarUrl =
                  'http://10.100.0.12/reforma360_api/${pub.autorFoto}';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabecera con avatar, nombre y tiempo
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
                                pub.autorNombre,
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
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Imagen con overlay
                      GestureDetector(
                        onTap: () => _showImageOverlay(context, imageUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                            errorBuilder:
                                (context, error, stack) =>
                                    const Text('Imagen no disponible'),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Descripción
                      Text(pub.descripcio),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error cargando feed: $err')),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }
}

/// Muestra la imagen en overlay con fondo difuminado y 16 px de margen.
/// Al tocar fuera de la imagen se cierra automáticamente.
void _showImageOverlay(BuildContext context, String imageUrl) {
  showGeneralDialog(
    context: context,
    barrierLabel: 'ImageOverlay',
    barrierDismissible: true,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black45),
            ),
            // Padding garantiza un margen mínimo alrededor de la imagen
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // 👈 margen mínimo
                child: GestureDetector(
                  onTap: () {}, // evita cierre al tocar la imagen
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InteractiveViewer(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (c, e, st) => const Text(
                              'Imagen no disponible',
                              style: TextStyle(color: Colors.white),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder:
        (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
  );
}
