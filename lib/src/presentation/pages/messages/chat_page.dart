import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reforma360/src/services/message_service.dart';

/// Chat entre usuario (currentUserId) y profesional (professionalId).
class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String professionalId;
  final String professionalName;
  final String professionalAvatarUrl;
  final DateTime? professionalLastSeenAt;

  const ChatPage({
    Key? key,
    required this.currentUserId,
    required this.professionalId,
    required this.professionalName,
    required this.professionalAvatarUrl,
    this.professionalLastSeenAt,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<List<Message>> _futureMessages;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    _futureMessages = MessageService.getMessages(
      userId: widget.currentUserId,
      professionalId: widget.professionalId,
    );
    setState(() {});
  }

  Future<void> _sendText() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    try {
      await MessageService.sendMessage(
        fromUserId: widget.currentUserId,
        toProfessionalId: widget.professionalId,
        body: text,
      );
      _controller.clear();
      _loadMessages();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al enviar: $e')));
    }
  }

  String _fullAvatarUrl(String relative) {
    // Si ya es absolute, la devolvemos tal cual
    if (relative.startsWith('http')) return relative;
    // Ajusta aquí tu host/API base si cambia
    return 'http://10.100.0.12/reforma360_api/$relative';
  }

  String _buildLastSeenLabel() {
    if (widget.professionalLastSeenAt == null) return 'En línea';
    final diff = DateTime.now().difference(widget.professionalLastSeenAt!);
    if (diff.inMinutes < 5) return 'En línea';
    return 'En línea hace ${diff.inMinutes}m';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Widget> _buildMessageWidgets(List<Message> messages, ThemeData theme) {
    final List<Widget> items = [];

    for (var i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final prev = i > 0 ? messages[i - 1] : null;

      // Insertamos etiqueta de fecha si cambia de día
      if (prev == null || !_isSameDay(prev.sentAt, msg.sentAt)) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                DateFormat('dd MMM yyyy').format(msg.sentAt),
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
            ),
          ),
        );
      }

      final isMe = msg.fromUserId == widget.currentUserId;
      final bubbleColor =
          isMe ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant;
      final textColor =
          isMe
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurfaceVariant;

      items.add(
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            margin: EdgeInsets.only(
              top: 6,
              bottom: 6,
              left: isMe ? 50 : 0,
              right: isMe ? 0 : 50,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              msg.body,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: textColor,
                height: 1.3,
              ),
            ),
          ),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget avatarWidget() {
      final url = widget.professionalAvatarUrl;
      // Si tenemos algo (sea absolute o relative), lo mostramos como imagen
      if (url.isNotEmpty) {
        final imageUrl = _fullAvatarUrl(url);
        return CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(imageUrl),
          onBackgroundImageError: (_, __) {
            // En caso de fallo, simplemente se quedará el color de fondo + child
          },
          child: Text(
            // Sobre el child: se pintará solo si la imagen falla
            widget.professionalName.isNotEmpty
                ? widget.professionalName[0]
                : '?',
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      // Si no hay URL, dibujo la letra
      return CircleAvatar(
        radius: 18,
        child: Text(
          widget.professionalName.isNotEmpty ? widget.professionalName[0] : '?',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Row(
          children: [
            avatarWidget(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.professionalName,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _buildLastSeenLabel(),
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: _futureMessages,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }

                final messages = snap.data ?? [];
                final widgets = _buildMessageWidgets(messages, theme);

                // Scroll al final
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });

                return ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  children: widgets,
                );
              },
            ),
          ),

          // Input
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: theme.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'Escribe algo...',
                                hintStyle: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.hintColor,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: _sendText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
