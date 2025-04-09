import 'package:flutter/material.dart';
import '../../widgets/shared/bottom_navigator.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: const Center(
        child: Text('Contenido del Feed'),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
    );
  }
}