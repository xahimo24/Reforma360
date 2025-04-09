import 'package:flutter/material.dart';
import '../../widgets/shared/bottom_navigator.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: const Center(
        child: Text('Contenido de Notificaciones'),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
    );
  }
}