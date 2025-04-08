class RegisterRequest {
  final String nom;
  final String cognoms;
  final String email;
  final String password;
  final String telefon;
  final bool tipus;
  final String foto;

  RegisterRequest({
    required this.nom,
    required this.cognoms,
    required this.email,
    required this.password,
    required this.telefon,
    required this.tipus,
    required this.foto,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'cognoms': cognoms,
      'email': email,
      'password': password,
      'telefon': telefon,
      'tipus': tipus ? 1 : 0,
      'foto': foto,
    };
  }
}
