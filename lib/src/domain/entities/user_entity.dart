class UserEntity {
  final int id;
  final String nom;
  final String cognoms;
  final String email;
  final String telefon;
  final bool tipus;
  final String foto;

  UserEntity({
    required this.id,
    required this.nom,
    required this.cognoms,
    required this.email,
    required this.telefon,
    required this.tipus,
    required this.foto,
  });
}
