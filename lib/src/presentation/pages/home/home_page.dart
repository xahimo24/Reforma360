import 'dart:ui'; // Llibreria per a efectes visuals com el desenfocament.
import 'package:flutter/material.dart'; // Llibreria principal de Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Llibreria per a la gestió de l'estat amb Riverpod.
import 'package:go_router/go_router.dart'; // Llibreria per a la navegació amb GoRouter.
import 'package:timeago/timeago.dart' as timeago; // Llibreria per mostrar dates relatives.

import '../../providers/publicacions/publicacions_provider.dart'; // Proveïdor de publicacions.
import '../../../core/routes/route_names.dart'; // Rutes de l'aplicació.
import '../../widgets/shared/bottom_navigator.dart'; // Widget compartit per a la navegació inferior.
import '../../providers/auth/auth_provider.dart'; // Proveïdor d'autenticació.

class HomePage extends ConsumerWidget { // Defineix un widget que utilitza Riverpod per accedir a l'estat global.
  const HomePage({Key? key}) : super(key: key); // Constructor de la classe HomePage.

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Mètode build per construir la interfície d'usuari.
    final feedAsync = ref.watch(publicacionsProvider); // Obté les publicacions del proveïdor.
    final user = ref.watch(userProvider); // Obté l'usuari actual.
    final avatarUrl =
        user != null // Comprova si l'usuari no és nul.
            ? user.foto.startsWith('http') // Si la foto de l'usuari comença amb 'http', utilitza aquesta URL.
                ? user.foto
                : 'http://10.100.0.12/reforma360_api/${user.foto}' // Si no, genera la URL completa afegint el domini base.
            : null; // Si l'usuari és nul, l'avatarUrl també serà nul.

    return Scaffold( // Retorna un Scaffold, que és l'estructura bàsica d'una pàgina a Flutter.
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add), // Icona per afegir una nova publicació.
          onPressed: () => context.go(RouteNames.newPost), // Navega a la pàgina de nova publicació.
        ),
        title: const Text('Reforma360'), // Títol de l'aplicació.
        centerTitle: true, // Centra el títol a la barra superior.
      ),
      body: feedAsync.when(
        data: (posts) { // Quan les dades estan disponibles.
          if (posts.isEmpty) {
            return const Center(child: Text("No hi ha publicacions encara.")); // Mostra un missatge si no hi ha publicacions.
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8), // Defineix el padding de la llista.
            itemCount: posts.length, // Nombre d'elements a la llista.
            itemBuilder: (context, i) {
              final pub = posts[i]; // Obté la publicació actual.
              final imageUrl =
                  'http://10.100.0.12/reforma360_api/${pub.contingut}'; // URL de la imatge de la publicació.
              final postAvatarUrl =
                  'http://10.100.0.12/reforma360_api/${pub.autorFoto}'; // URL de l'avatar de l'autor.

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Defineix el marge de la targeta.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Defineix les vores arrodonides.
                ),
                elevation: 2, // Defineix l'elevació de la targeta.
                child: Padding(
                  padding: const EdgeInsets.all(12), // Defineix el padding intern de la targeta.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ───── Capçalera amb avatar, nom i temps ─────
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(postAvatarUrl), // Mostra l'avatar de l'autor.
                            radius: 18,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pub.autorNombre, // Mostra el nom de l'autor.
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                timeago.format(pub.dataPublicacio), // Mostra la data relativa de la publicació.
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.more_horiz), // Icona de menú.
                            onPressed: () {}, // Acció per al menú (actualment buida).
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ───── Imatge amb overlay ─────
                      GestureDetector(
                        onTap: () => _showImageOverlay(context, imageUrl), // Mostra la imatge en un overlay.
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12), // Arrodoneix les vores de la imatge.
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover, // Ajusta la imatge al contenidor.
                            width: double.infinity,
                            height: 200,
                            errorBuilder: (context, error, stack) =>
                                const Text('Imatge no disponible'), // Mostra un missatge si la imatge no es carrega.
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ───── Descripció ─────
                      Text(pub.descripcio), // Mostra la descripció de la publicació.
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()), // Mostra un indicador de càrrega.
        error: (err, _) => Center(child: Text('Error en carregar el feed: $err')), // Mostra un error si falla.
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 0, // Índex actual (Home).
        userAvatarUrl: avatarUrl, // Passa la URL de l'avatar de l'usuari.
      ),
    );
  }
}

/// Mostra la imatge en overlay amb un fons difuminat i un marge de 16 px.
/// Al tocar fora de la imatge, es tanca automàticament.
void _showImageOverlay(BuildContext context, String imageUrl) {
  showGeneralDialog(
    context: context,
    barrierLabel: 'ImageOverlay', // Etiqueta per al diàleg.
    barrierDismissible: true, // Permet tancar el diàleg tocant fora.
    barrierColor: Colors.black45, // Color del fons del diàleg.
    transitionDuration: const Duration(milliseconds: 200), // Durada de la transició.
    pageBuilder: (_, __, ___) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(), // Tanca el diàleg al tocar fora.
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Aplica un efecte de desenfocament.
              child: Container(color: Colors.black45), // Fons amb opacitat.
            ),
            // Padding garanteix un marge mínim al voltant de la imatge.
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Marge mínim.
                child: GestureDetector(
                  onTap: () {}, // Evita tancar el diàleg al tocar la imatge.
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12), // Arrodoneix les vores de la imatge.
                    child: InteractiveViewer(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain, // Ajusta la imatge al contenidor.
                        errorBuilder: (c, e, st) => const Text(
                          'Imatge no disponible',
                          style: TextStyle(color: Colors.white),
                        ), // Mostra un missatge si la imatge no es carrega.
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
    transitionBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child), // Aplica una transició de fade.
  );
}
