import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '../../../core/routes/route_names.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:reforma360/src/core/theme/app_theme.dart';

class NewPostPage extends ConsumerStatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends ConsumerState<NewPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();

  File? _imageFile;
  bool _isSubmitting = false;
  String? _currentCity;

  /// Predefined hashtags
  final List<String> _presetTags = [
    '#reformando',
    '#pintando',
    '#fontanería',
    '#electricidad',
    '#decoración',
    '#carpintería',
    '#jardinería',
    '#mampostería',
    '#alicatado',
    '#impermeabilización',
    '#techos',
    '#suelos',
    '#pavimentos',
    '#iluminación',
    '#ventanas',
    '#puertas',
    '#climatización',
    '#seguridad',
    '#automatización',
    '#energíarenovable',
    '#domótica',
    '#estiloindustrial',
    '#minimalismo',
    '#restauración',
    '#mueblesamedida',
    '#renovación',
    '#acústica',
    '#revestimientos',
    '#pinturadeexterior',
    '#salpicaderos',
    '#cerámica',
    '#vidrio',
    '#metalistería',
    '#yeso',
    '#pladur',
    '#estructuras',
    '#sistemasdeagua',
    '#sistemaselectricos',
  ];

  Future<void> _pickImage() async {
    final pic = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pic != null) setState(() => _imageFile = File(pic.path));
  }

  Future<void> _takePhoto() async {
    final pic = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pic != null) setState(() => _imageFile = File(pic.path));
  }

  Future<void> _insertTag(String tag) async {
    final text = _descController.text;
    if (!text.contains(tag)) {
      _descController.text = text.isEmpty ? '$tag ' : '$text $tag ';
      _descController.selection = TextSelection.fromPosition(
        TextPosition(offset: _descController.text.length),
      );
    }
  }

  Future<void> _locateMe() async {
    // 1) Asegurarnos de que el servicio de localización está activo
    if (!await Geolocator.isLocationServiceEnabled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activa el servicio de ubicación')),
      );
      return;
    }

    // 2) Comprobar y pedir permiso si hace falta
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado')),
      );
      return;
    }

    try {
      // 3) Intentar obtener posición, con timeout para no colgarse
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );

      // 4) Reverse-geocoding
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isNotEmpty) {
        final city = placemarks.first.locality ?? '';
        setState(() => _currentCity = city);
        await _insertTag('#${city.replaceAll(' ', '')}');
      }
    } catch (e) {
      // 5) Fallback: si no hay fix rápido, intenta con la última conocida
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        final placemarks = await placemarkFromCoordinates(
          last.latitude,
          last.longitude,
        );
        if (placemarks.isNotEmpty) {
          final city = placemarks.first.locality ?? '';
          setState(() => _currentCity = city);
          await _insertTag('#${city.replaceAll(' ', '')}');
          return;
        }
      }

      // Finalmente, mostramos error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error localizando: $e')),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una imagen')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final user = ref.read(userProvider)!;
      final uri = Uri.parse(
          'http://10.100.0.12/reforma360_api/create_publication.php');
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = user.id.toString()
        ..fields['description'] = _descController.text
        ..files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final json = jsonDecode(body);

      if (response.statusCode == 200 && json['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación creada')),
        );
        context.go(RouteNames.home);
      } else {
        throw Exception(json['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Publicación'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.home),
        ),
        actions: [
          IconButton(
            icon: _isSubmitting
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.iconTheme.color,
              ),
            )
                : const Icon(Icons.check),
            onPressed: _isSubmitting ? null : _submit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  hintText: 'Escribe tu descripción...',
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                minLines: 3,
                maxLines: 6,
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Descripción obligatoria' : null,
              ),
            ),
            const SizedBox(height: 12),
            if (_imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _imageFile!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _presetTags.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  if (i == 0) {
                    // Ahora “Mi ciudad” va primero
                    return OutlinedButton.icon(
                      icon: const Icon(Icons.my_location),
                      label: const Text('Mi ciudad'),
                      onPressed: _locateMe,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide.none,
                      ),
                    );
                  }
                  // Para i > 0, el hashtag en posición i-1
                  final tag = _presetTags[i - 1];
                  return OutlinedButton(
                    onPressed: () => _insertTag(tag),
                    child: Text(tag, style: TextStyle(color: theme.colorScheme.primary)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide.none,
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon:
                  Icon(Icons.image, color: theme.colorScheme.primary, size: 28),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt,
                      color: theme.colorScheme.primary, size: 28),
                  onPressed: _takePhoto,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
