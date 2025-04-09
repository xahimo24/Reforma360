class PublicacioModel {
  final int id;
  final int idUsuari;
  final String descripcio;
  final String contingut;
  final DateTime dataPublicacio;

  PublicacioModel({
    required this.id,
    required this.idUsuari,
    required this.descripcio,
    required this.contingut,
    required this.dataPublicacio,
  });

  factory PublicacioModel.fromJson(Map<String, dynamic> json) {
    return PublicacioModel(
      id: int.parse(json['id'].toString()),
      idUsuari: int.parse(json['id_usuari'].toString()),
      descripcio: json['descripcio'],
      contingut: json['contingut'],
      dataPublicacio: DateTime.parse(json['data_publicacio']),
    );
  }
}
