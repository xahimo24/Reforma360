// lib/src/presentation/data/models/professional_model.dart

class ProfessionalDetailModel {
  final int id;
  final String nom;
  final String cognoms;
  final String email;
  final String telefon;
  final String foto;
  final String especialitat;
  final double valoracio;
  final int numValoracions;
  final String descripcio;
  final List<String> serveis;
  final List<String> zones;
  final List<String> idiomes;
  final List<String> certificacions;
  final List<String> projectes;
  final List<String> valoracions;
  final List<String> fotos;
  final List<String> videos;
  final List<String> documents;
  final List<String> contactes;
  final List<String> xarxes;
  final List<String> horaris;
  final List<String> disponibilitats;
  final List<String> preus;
  final List<String> pagaments;
  final List<String> garanties;
  final List<String> assegurances;
  final List<String> certificats;
  final List<String> llicencies;
  final List<String> permisos;
  final List<String> altres;

  ProfessionalDetailModel({
    required this.id,
    required this.nom,
    required this.cognoms,
    required this.email,
    required this.telefon,
    required this.foto,
    required this.especialitat,
    required this.valoracio,
    required this.numValoracions,
    required this.descripcio,
    required this.serveis,
    required this.zones,
    required this.idiomes,
    required this.certificacions,
    required this.projectes,
    required this.valoracions,
    required this.fotos,
    required this.videos,
    required this.documents,
    required this.contactes,
    required this.xarxes,
    required this.horaris,
    required this.disponibilitats,
    required this.preus,
    required this.pagaments,
    required this.garanties,
    required this.assegurances,
    required this.certificats,
    required this.llicencies,
    required this.permisos,
    required this.altres,
  });

  factory ProfessionalDetailModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalDetailModel(
      id: json['id'] as int,
      nom: json['nom'] as String,
      cognoms: json['cognoms'] as String,
      email: json['email'] as String,
      telefon: json['telefon'] as String,
      foto: json['foto'] as String,
      especialitat: json['especialitat'] as String,
      valoracio: json['valoracio'] as double,
      numValoracions: json['numValoracions'] as int,
      descripcio: json['descripcio'] as String,
      serveis: List<String>.from(json['serveis'] as List),
      zones: List<String>.from(json['zones'] as List),
      idiomes: List<String>.from(json['idiomes'] as List),
      certificacions: List<String>.from(json['certificacions'] as List),
      projectes: List<String>.from(json['projectes'] as List),
      valoracions: List<String>.from(json['valoracions'] as List),
      fotos: List<String>.from(json['fotos'] as List),
      videos: List<String>.from(json['videos'] as List),
      documents: List<String>.from(json['documents'] as List),
      contactes: List<String>.from(json['contactes'] as List),
      xarxes: List<String>.from(json['xarxes'] as List),
      horaris: List<String>.from(json['horaris'] as List),
      disponibilitats: List<String>.from(json['disponibilitats'] as List),
      preus: List<String>.from(json['preus'] as List),
      pagaments: List<String>.from(json['pagaments'] as List),
      garanties: List<String>.from(json['garanties'] as List),
      assegurances: List<String>.from(json['assegurances'] as List),
      certificats: List<String>.from(json['certificats'] as List),
      llicencies: List<String>.from(json['llicencies'] as List),
      permisos: List<String>.from(json['permisos'] as List),
      altres: List<String>.from(json['altres'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'cognoms': cognoms,
      'email': email,
      'telefon': telefon,
      'foto': foto,
      'especialitat': especialitat,
      'valoracio': valoracio,
      'numValoracions': numValoracions,
      'descripcio': descripcio,
      'serveis': serveis,
      'zones': zones,
      'idiomes': idiomes,
      'certificacions': certificacions,
      'projectes': projectes,
      'valoracions': valoracions,
      'fotos': fotos,
      'videos': videos,
      'documents': documents,
      'contactes': contactes,
      'xarxes': xarxes,
      'horaris': horaris,
      'disponibilitats': disponibilitats,
      'preus': preus,
      'pagaments': pagaments,
      'garanties': garanties,
      'assegurances': assegurances,
      'certificats': certificats,
      'llicencies': llicencies,
      'permisos': permisos,
      'altres': altres,
    };
  }
}
