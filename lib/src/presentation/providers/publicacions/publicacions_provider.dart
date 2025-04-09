import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/remote/publicacions_remote_ds.dart';
import '../../../data/models/publicacio_model.dart';

final publicacionsRemoteDSProvider = Provider(
  (ref) => PublicacionsRemoteDataSource(),
);

final publicacionsProvider = FutureProvider.autoDispose<List<PublicacioModel>>((
  ref,
) async {
  final ds = ref.read(publicacionsRemoteDSProvider);
  return ds.getPublicacions(); // <--- Este método DEBE existir
});
