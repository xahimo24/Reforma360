// lib/src/data/models/professional_model.dart

/// Modelo que representa un profesional en la plataforma.
class ProfessionalModel {
  final int id; // ID en tabla `profesionals`.
  final int userId; // ID de usuario (usuaris.id).
  final String userName; // Nombre completo (usuaris.nom).
  final String userAvatar; // Ruta relativa a la foto (usuaris.foto).
  final int categoryId; // ID de la categoría (categoria.id_categoria).
  final String categoryName; // Nombre de la categoría (categoria.nom).
  final int experience; // Años de experiencia.
  final String description; // Descripción.
  final String city; // Ciudad.
  final double avgRating; // Valoración promedio.
  final int reviewsCount; // Número de valoraciones.

  ProfessionalModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.categoryId,
    required this.categoryName,
    required this.experience,
    required this.description,
    required this.city,
    required this.avgRating,
    required this.reviewsCount,
  });

  /// Crea un ProfessionalModel desde el JSON de la API.
  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    // Helpers para parseo seguro
    int safeInt(dynamic v) {
      if (v == null) return 0;
      return int.tryParse(v.toString()) ?? 0;
    }

    double safeDouble(dynamic v) {
      if (v == null) return 0.0;
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return ProfessionalModel(
      id: safeInt(json['id']),
      userId: safeInt(json['id_usuari']),
      userName: json['user_name'] as String? ?? '',
      userAvatar: json['user_avatar'] as String? ?? '',
      categoryId: safeInt(json['category_id']),
      categoryName: json['category_name'] as String? ?? 'Sin categoría',
      experience: safeInt(json['experiencia']),
      description: json['descripcio'] as String? ?? '',
      city: json['ciudad'] as String? ?? '',
      avgRating: safeDouble(json['avg_rating']),
      reviewsCount: safeInt(json['reviews_count']),
    );
  }
}
