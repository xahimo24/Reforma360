import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/remote/publicacions_remote_ds.dart';
import '../../../data/models/publicacio_model.dart';

final publicacionsRemoteDSProvider = Provider(
  (ref) => PublicacionsRemoteDataSource(),
);

final createPublicationProvider = FutureProvider.family
    .autoDispose<PublicacioModel, Map<String, dynamic>>((ref, params) async {
      final ds = ref.read(publicacionsRemoteDSProvider);
      return ds.createPublication(
        userId: params['userId'] as int,
        description: params['description'] as String,
        imageFile: params['imageFile'] as File,
      );
    });
