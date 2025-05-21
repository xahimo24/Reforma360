// file: lib/src/presentation/pages/messages/messages_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/message_service.dart';
import '../../providers/auth/auth_provider.dart';
import '../../../core/routes/route_names.dart';
import 'package:reforma360/src/presentation/widgets/shared/bottom_navigator.dart';

/// Convierte una ruta relativa en URL absoluta apuntando a tu API
String _fullImageUrl(String relative) {
  if (relative.startsWith('http')) return relative;
  return 'http://10.100.0.12/reforma360_api/$relative';
}

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

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final rawAvatar = user?.foto ?? '';
    final avatarUrl =
        rawAvatar.startsWith('http')
            ? rawAvatar
            : rawAvatar.isNotEmpty
            ? 'http://10.100.0.12/reforma360_api/$rawAvatar'
            : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          // ─── Buscador ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _searchTerm = v),
            ),
          ),

          // ─── Lista de conversaciones ────────────────────────────
          Expanded(
            child: FutureBuilder<List<Conversation>>(
              future: _futureConversations,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final all = snapshot.data ?? [];
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
                          pathParameters: {
                            'conversationId': conv.professionalId,
                          },
                          extra: {
                            'professionalId': conv.professionalId,
                            'professionalName': conv.professionalName,
                            'professionalAvatarUrl': conv.professionalAvatarUrl,
                          },
                        );
                      },
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          _fullImageUrl(conv.professionalAvatarUrl),
                        ),
                        onBackgroundImageError: (_, __) {},
                        child:
                            conv.professionalAvatarUrl.isEmpty
                                ? Text(conv.professionalName[0])
                                : null,
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 3,
        userAvatarUrl: avatarUrl,
      ),
    );
  }
}
