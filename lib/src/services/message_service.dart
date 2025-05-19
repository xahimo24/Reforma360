// file: lib/src/services/message_service.dart
// --- Extensión: métodos para manejar mensajes individuales y modelo Message ---

import 'dart:convert';
import 'package:http/http.dart' as http;

class Conversation {
  final int id;
  final String professionalName;
  final String lastMessage;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.professionalName,
    required this.lastMessage,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['conversationId'] as int,
      professionalName: json['professionalName'] as String,
      lastMessage: json['lastMessage'] as String,
      updatedAt: DateTime.parse(json['updatedAt'].toString()),
    );
  }
}

class MessageService {
  /// Obtiene las conversaciones del usuario
  static Future<List<Conversation>> getConversations({
    required String userId,
  }) async {
    final uri = Uri.parse(
      'http://10.100.0.12/reforma360_api/get_conversations.php?userId=$userId',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['conversations'] is List) {
        final list = data['conversations'] as List;
        return list
            .map((item) => Conversation.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    }
    throw Exception('Error al cargar conversaciones: ${response.statusCode}');
  }

  /// Envía una solicitud de presupuesto
  static Future<int> sendQuoteRequest({
    required String fromUserId,
    required String toProfessionalId,
    required String subject,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.100.0.12/reforma360_api/send_message.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fromUserId': fromUserId,
        'toProfessionalId': toProfessionalId,
        'body': body,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['conversationId'] != null) {
        return data['conversationId'] as int;
      }
      throw Exception('Respuesta inválida del servidor: ${response.body}');
    } else {
      // Aquí atrapas el JSON de error que envía PHP
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}

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

extension MessageServiceMessages on MessageService {
  /// Obtiene los mensajes de una conversación
  static Future<List<Message>> getMessages({
    required int conversationId,
  }) async {
    final uri = Uri.parse(
      'http://10.100.0.12/reforma360_api/get_messages.php?conversationId=$conversationId',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['messages'] is List) {
        final list = data['messages'] as List;
        return list
            .map((item) => Message.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    }
    throw Exception('Error al cargar mensajes: ${response.statusCode}');
  }

  /// Envía un mensaje de texto dentro de una conversación existente
  static Future<void> sendMessage({
    required int conversationId,
    required String fromUserId,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.100.0.12/reforma360_api/send_message.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'conversationId': conversationId,
        'fromUserId': fromUserId,
        'body': body,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al enviar mensaje: ${response.statusCode}');
    }
  }
}
