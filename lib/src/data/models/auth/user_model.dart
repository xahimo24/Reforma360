class UserModel {
  final int id;
  final String nom;
  final String cognoms;
  final String email;
  final String telefon;
  final bool tipus;
  final String foto;
  final String? bio; // 👈 nuevo campo opcional

  UserModel({
    required this.id,
    required this.nom,
    required this.cognoms,
    required this.email,
    required this.telefon,
    required this.tipus,
    required this.foto,
    this.bio, // 👈 lo añadimos al constructor
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id'].toString()),
      nom: json['nom'] ?? '',
      cognoms: json['cognoms'] ?? '',
      email: json['email'] ?? '',
      telefon: json['telefon'] ?? '',
      tipus: json['tipus'].toString() == '1',
      foto: json['foto'] ?? '',
      bio: json['bio'], // 👈 lo mapeamos desde el JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'cognoms': cognoms,
      'email': email,
      'telefon': telefon,
      'tipus': tipus ? 1 : 0,
      'foto': foto,
      'bio': bio, // 👈 lo incluimos si lo quieres enviar al servidor
    };
  }
}