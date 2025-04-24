import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_names.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final String? userAvatarUrl; // Nuevo parámetro para la URL de avatar


  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    this.userAvatarUrl, // Opcional para mantener retrocompatibilidad
  }) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.go(RouteNames.feed);
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
  }

  @override
  Widget build(BuildContext context) {
    // Crear los items individualmente en lugar de usar const en todo el array
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Inicio',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Buscar',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Notificaciones',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: 'Mensajes',
      ),
      // El item del perfil ya no es constante
      BottomNavigationBarItem(
        icon: userAvatarUrl != null && userAvatarUrl!.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(userAvatarUrl!),
                radius: 14,
              )
            : const Icon(Icons.person),
        label: 'Perfil',
      ),
    ];

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: items,
    );
  }
}