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
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    _futureConversations = MessageService.getConversations(
      userId: widget.userId,
    );
    setState(() {});
  }

  // Helper para formatear relative time (muy básico)
  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final avatarUrl =
        (user != null && user.foto.startsWith('http')) ? user.foto : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Busca conversaciones…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _searchTerm = v),
            ),
          ),
        ),
        elevation: 1,
      ),
      body: FutureBuilder<List<Conversation>>(
        future: _futureConversations,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final all = snapshot.data ?? [];
          // Aplicamos filtro local por nombre o último mensaje
          final filtered =
              all.where((c) {
                final term = _searchTerm.toLowerCase();
                return c.professionalName.toLowerCase().contains(term) ||
                    c.lastMessage.toLowerCase().contains(term);
              }).toList();

          if (filtered.isEmpty) {
            return const Center(
              child: Text('No se han encontrado conversaciones.'),
            );
          }

          return ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(indent: 72),
            itemBuilder: (ctx, i) {
              final conv = filtered[i];
              final timeAgo = _formatTimeAgo(conv.updatedAt);
              final preview =
                  conv.lastMessage.length > 30
                      ? '${conv.lastMessage.substring(0, 30)}…'
                      : conv.lastMessage;

              return ListTile(
                onTap: () {
                  context.pushNamed(
                    RouteNames.chat,
                    pathParameters: {'conversationId': conv.professionalId},
                    extra: {
                      'professionalId': conv.professionalId,
                      'professionalName': conv.professionalName,
                      'professionalAvatarUrl': conv.professionalAvatarUrl,
                    },
                  );
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(conv.professionalAvatarUrl),
                ),
                title: Text(
                  conv.professionalName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(preview),
                trailing: Text(timeAgo),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
