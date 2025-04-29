// lib/src/data/models/professional_model.dart

/// Modelo que representa un profesional en la plataforma.
class ProfessionalModel {
  final int id; // ID en tabla Profesionals
  final int userId; // ID de usuario
  final String userName; // Nombre completo (Usuaris.nom)
  final String userAvatar; // Ruta relativa a la foto (Usuaris.foto)
  final String category; // Profesión / categoría
  final int experience; // Años de experiencia
  final String description; // Descripción
  final String city; // Ciudad
  final double avgRating; // Valoración promedio
  final int reviewsCount; // Número de valoraciones

  ProfessionalModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.category,
    required this.experience,
    required this.description,
    required this.city,
    required this.avgRating,
    required this.reviewsCount,
  });

  /// Crea un ProfessionalModel desde el JSON de la API.
  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['id_usuari'].toString()),
      userName: json['user_name'] ?? '',
      userAvatar: json['user_avatar'] ?? '',
      category: json['categoria'] ?? '',
      experience: int.parse(json['experiencia'].toString()),
      description: json['descripcion'] ?? '',
      city: json['ciudad'] ?? '',
      avgRating: double.parse(json['avg_rating'].toString()),
      reviewsCount: int.parse(json['reviews_count'].toString()),
    );
  }
}
