import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/remote/publicacions_remote_ds.dart';
import '../../../data/models/publicacio_model.dart';

// Este provider crea la instancia de tu DataSource
final publicacionsRemoteDSProvider = Provider<PublicacionsRemoteDataSource>((
  ref,
) {
  return PublicacionsRemoteDataSource();
});

// Este provider usa FutureProvider.family para traer publicaciones por userId
final userPublicationsProvider =
    FutureProvider.family<List<PublicacioModel>, int>((ref, userId) async {
      final ds = ref.read(publicacionsRemoteDSProvider);
      return ds.getPublicacionesByUser(userId);
    });
