import '../models/auth/user_model.dart';
import '../../domain/entities/user_entity.dart';

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nom: nom,
      cognoms: cognoms,
      email: email,
      telefon: telefon,
      tipus: tipus,
      foto: foto,
    );
  }
}
