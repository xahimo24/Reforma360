// file: lib/src/presentation/pages/messages/messages_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/message_service.dart';
import '../../providers/auth/auth_provider.dart';
import '../../../core/routes/route_names.dart';
import 'package:reforma360/src/presentation/widgets/shared/bottom_navigator.dart';

class MessagesPage extends ConsumerStatefulWidget {
  final String userId;
  const MessagesPage({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  late Future<List<Conversation>> _futureConversations;

  @override
  void initState() {
    super.initState();
    _futureConversations = MessageService.getConversations(
      userId: widget.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final avatarUrl =
        (user != null && user.foto.startsWith('http')) ? user.foto : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes'), centerTitle: true),
      body: FutureBuilder<List<Conversation>>(
        future: _futureConversations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final conversations = snapshot.data ?? [];
          if (conversations.isEmpty) {
            return const Center(child: Text('No tienes conversaciones.'));
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (ctx, index) {
              final conv = conversations[index];
              final dateStr = conv.updatedAt.toLocal().toString().split(' ')[0];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    conv.professionalName.isNotEmpty
                        ? conv.professionalName[0]
                        : '?',
                  ),
                ),
                title: Text(conv.professionalName),
                subtitle: Text(conv.lastMessage),
                trailing: Text(dateStr),
                onTap: () {
                  context.pushNamed(
                    RouteNames.chat,
                    pathParameters: {
                      'conversationId':
                          conv.professionalId, // ¡ojo! aquí usamos professionalId
                    },
                    extra: {
                      'professionalId': conv.professionalId,
                      'professionalName': conv.professionalName,
                      'professionalAvatarUrl': conv.professionalAvatarUrl,
                    },
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 3,
        userAvatarUrl: avatarUrl,
      ),
    );
  }
}
