class PublicacioModel {
  final int id;
  final int idUsuari;
  final String descripcio;
  final String contingut;
  final DateTime dataPublicacio;

  // Nuevos campos que vienen desde la tabla Usuaris
  final String autorNombre;
  final String autorFoto;

  PublicacioModel({
    required this.id,
    required this.idUsuari,
    required this.descripcio,
    required this.contingut,
    required this.dataPublicacio,
    required this.autorNombre,
    required this.autorFoto,
  });

  factory PublicacioModel.fromJson(Map<String, dynamic> json) {
    return PublicacioModel(
      id: int.parse(json['id'].toString()),
      idUsuari: int.parse(json['id_usuari'].toString()),
      descripcio: json['descripcio'],
      contingut: json['contingut'],
      dataPublicacio: DateTime.parse(json['data_publicacio']),
      autorNombre: json['autor_nombre'] ?? 'Usuario',
      autorFoto:
          json['autor_foto'] ??
          '', // Puedes poner una imagen por defecto si está vacío
    );
  }
}
