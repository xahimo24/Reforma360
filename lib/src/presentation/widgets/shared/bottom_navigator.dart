// lib/src/presentation/widgets/shared/bottom_navigation.dart
// -----------------------------------------------------------------------------
// Widget personalitzat per a la barra de navegació inferior
// (Manté TOTS els teus comentaris, només s’ha canviat el cas 1)
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Importa el paquet de navegació go_router
import '../../../core/routes/route_names.dart'; // Importa les constants dels noms de rutes

// Widget personalitzat per a la barra de navegació inferior
class BottomNavigation extends StatelessWidget {
  final int currentIndex; // Índex actual per ressaltar l'element seleccionat
  final String?
  userAvatarUrl; // URL opcional per mostrar la foto de perfil de l'usuari

  // Constructor amb paràmetres requerits i opcionals
  const BottomNavigation({
    Key? key,
    required this.currentIndex, // L'índex actual és obligatori
    this.userAvatarUrl, // L'URL de l'avatar és opcional per mantenir compatibilitat
  }) : super(key: key);

  // Mètode que gestiona la navegació quan es toca un element
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home); // Navega a la pàgina d'inici
        break;
      case 1:
        context.go(
          RouteNames.professionals,
        ); // ← Ara navega a la pàgina de professionals
        break;
      case 2:
        context.go(
          RouteNames.notifications,
        ); // Navega a la pàgina de notificacions
        break;
      case 3:
        context.go(RouteNames.messages); // Navega a la pàgina de missatges
        break;
      case 4:
        context.go(RouteNames.profile); // Navega a la pàgina de perfil
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Crea els elements de navegació individualment per poder usar-ne un no constant (el perfil)
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home), // Icona de casa per a la pàgina d'inici
        label: 'Inicio',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search), // Icona de cerca
        label: 'Profesionales', // ← Etiqueta actualitzada
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.notifications), // Icona de notificacions
        label: 'Notificaciones',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.message), // Icona de missatges
        label: 'Mensajes',
      ),
      // L'element del perfil és especial perquè pot mostrar la foto de l'usuari
      BottomNavigationBarItem(
        icon:
            userAvatarUrl != null && userAvatarUrl!.isNotEmpty
                ? CircleAvatar(
                  // Si hi ha URL d'avatar, mostra un cercle amb la imatge
                  backgroundImage: NetworkImage(userAvatarUrl!),
                  radius: 14, // Mida més petita que les icones normals
                )
                : const Icon(
                  Icons.person,
                ), // Si no hi ha URL, mostra una icona genèrica de persona
        label: 'Perfil',
      ),
    ];

    // Retorna el widget BottomNavigationBar amb la configuració adequada
    return BottomNavigationBar(
      currentIndex:
          currentIndex, // Estableix quin element ha d'estar seleccionat/ressaltat
      onTap:
          (index) =>
              _onItemTapped(context, index), // Gestiona els tocs als elements
      items: items, // Utilitza la llista d'elements creada anteriorment
    );
  }
}
