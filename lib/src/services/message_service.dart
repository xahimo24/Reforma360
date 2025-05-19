// file: lib/src/services/message_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Modelo de conversación con un profesional.
class Conversation {
  final int id;
  final String professionalName;
  final String professionalAvatarUrl;
  final String lastMessage;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.professionalName,
    required this.professionalAvatarUrl,
    required this.lastMessage,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['conversationId'] as int,
      professionalName: json['professionalName'] as String,
      professionalAvatarUrl: json['professionalAvatarUrl'] as String,
      lastMessage: json['lastMessage'] as String,
      updatedAt: DateTime.parse(json['updatedAt'].toString()),
    );
  }
}

/// Modelo de mensaje individual.
class Message {
  final int id;
  final int conversationId;
  final String fromUserId;
  final String body;
  final DateTime sentAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.fromUserId,
    required this.body,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['messageId'] as int,
      conversationId: json['conversationId'] as int,
      fromUserId: json['fromUserId'].toString(),
      body: json['body'].toString(),
      sentAt: DateTime.parse(json['sentAt'].toString()),
    );
  }
}

/// Servicio para manejar conversaciones y mensajes.
class MessageService {
  /// Obtiene las conversaciones del usuario.
  static Future<List<Conversation>> getConversations({
    required String userId,
  }) async {
    final uri = Uri.parse(
      'http://10.100.0.12/reforma360_api/get_conversations.php?userId=$userId',
    );
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Error al cargar conversaciones: ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body);
    if (data['success'] == true && data['conversations'] is List) {
      return (data['conversations'] as List)
          .map((j) => Conversation.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Envía una solicitud de presupuesto (inicia conversación si no existe).
  static Future<int> sendQuoteRequest({
    required String fromUserId,
    required String toProfessionalId,
    required String subject,
    required String body,
  }) async {
    final resp = await http.post(
      Uri.parse('http://10.100.0.12/reforma360_api/send_message.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fromUserId': fromUserId,
        'toProfessionalId': toProfessionalId,
        'subject': subject,
        'body': body,
      }),
    );
    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }
    final data = jsonDecode(resp.body);
    if (data['success'] == true && data['conversationId'] != null) {
      return data['conversationId'] as int;
    }
    throw Exception('Respuesta inválida del servidor: ${resp.body}');
  }

  /// Obtiene los mensajes de una conversación.
  static Future<List<Message>> getMessages({
    required int conversationId,
    required String currentUserId,
  }) async {
    final uri = Uri(
      scheme: 'http',
      host: '10.100.0.12',
      path: '/reforma360_api/get_messages.php',
      queryParameters: {
        'conversationId': conversationId.toString(),
        'userId': currentUserId,
      },
    );
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Error al cargar mensajes: ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body);
    if (data['success'] == true && data['messages'] is List) {
      return (data['messages'] as List)
          .map((j) => Message.fromJson(j as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Envía un mensaje de texto dentro de una conversación existente.
  static Future<void> sendMessage({
    required int conversationId,
    required String fromUserId,
    required String body,
  }) async {
    final resp = await http.post(
      Uri.parse('http://10.100.0.12/reforma360_api/send_message.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'conversationId': conversationId,
        'fromUserId': fromUserId,
        'body': body,
      }),
    );
    if (resp.statusCode != 200) {
      throw Exception('Error al enviar mensaje: ${resp.statusCode}');
    }
  }
}
