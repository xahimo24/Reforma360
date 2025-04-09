import 'package:flutter/material.dart';
import '../../widgets/shared/bottom_navigator.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
      ),
      body: const Center(
        child: Text('Contenido de Mensajes'),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 3),
    );
  }
}