import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/remote/publicacions_remote_ds.dart';
import '../../../data/models/publicacio_model.dart';

final publicacionsRemoteDSProvider = Provider(
  (ref) => PublicacionsRemoteDataSource(),
);

/// Devuelve SOLO las publicaciones del usuario [userId]
final userPublicationsProvider =
    FutureProvider.family<List<PublicacioModel>, int>((ref, userId) async {
      final ds = ref.read(publicacionsRemoteDSProvider);
      final all = await ds.getPublicacions(); // ← método existente
      // Asegúrate de que tu modelo tenga `idUsuari`
      return all.where((p) => p.idUsuari == userId).toList();
    });
