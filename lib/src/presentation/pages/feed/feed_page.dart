import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/shared/bottom_navigator.dart';
import '../../providers/auth/auth_provider.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({Key? key}) : super(key: key);

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
      appBar: AppBar(title: const Text('Feed')),
      body: const Center(child: Text('Contenido del Feed')),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 1,
        userAvatarUrl: avatarUrl,
      ),
    );
  }
}
