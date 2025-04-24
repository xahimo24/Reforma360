import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/shared/bottom_navigator.dart';
import '../../providers/auth/auth_provider.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final avatarUrl =
        user != null
            ? user.foto.startsWith('http')
                ? user.foto
                : 'http://10.100.0.12/reforma360_api/${user.foto}'
            : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: const Center(child: Text('Contenido de Notificaciones')),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 2,
        userAvatarUrl: avatarUrl,
      ),
    );
  }
}
