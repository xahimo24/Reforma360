import 'package:flutter/material.dart'; // Llibreria principal de Flutter per a la creació d'interfícies d'usuari.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Llibreria per a la gestió de l'estat amb Riverpod.
import '../../widgets/shared/bottom_navigator.dart'; // Widget compartit per a la barra de navegació inferior.
import '../../providers/auth/auth_provider.dart'; // Proveïdor d'autenticació per obtenir informació de l'usuari.

class MessagesPage extends ConsumerWidget { // Defineix un widget que utilitza Riverpod per accedir a l'estat global.
  const MessagesPage({Key? key}) : super(key: key); // Constructor de la classe MessagesPage.

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Mètode build per construir la interfície d'usuari.
    final user = ref.watch(userProvider); // Obté l'usuari actual des del proveïdor userProvider.
    final avatarUrl =
        user != null // Comprova si l'usuari no és nul.
            ? user.foto.startsWith('http') // Si la foto de l'usuari comença amb 'http', utilitza aquesta URL.
                ? user.foto
                : 'http://10.100.0.12/reforma360_api/${user.foto}' // Si no, genera la URL completa afegint el domini base.
            : null; // Si l'usuari és nul, l'avatarUrl també serà nul.

    return Scaffold( // Retorna un Scaffold, que és l'estructura bàsica d'una pàgina a Flutter.
      appBar: AppBar(title: const Text('Mensajes')), // Barra superior amb el títol "Mensajes".
      body: const Center(child: Text('Contenido de Mensajes')), // Contingut central de la pàgina, actualment un text estàtic.
      bottomNavigationBar: BottomNavigation( // Barra de navegació inferior.
        currentIndex: 3, // Índex actual de la pàgina (3 indica que és la pàgina de Missatges).
        userAvatarUrl: avatarUrl, // Passa la URL de l'avatar de l'usuari al widget BottomNavigation.
      ),
    );
  }
}
