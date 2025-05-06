// lib/src/presentation/pages/auth/register_photo_page.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../core/routes/route_names.dart';
import '../../providers/auth/auth_provider.dart'; // loginProvider
import '../../../data/models/auth/login_request.dart'; // LoginRequest

class RegisterPhotoPage extends ConsumerStatefulWidget {
  final int userId;
  final bool isProfessional;
  final String email;
  final String password;

  const RegisterPhotoPage({
    Key? key,
    required this.userId,
    required this.isProfessional,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _RegisterPhotoPageState createState() => _RegisterPhotoPageState();
}

class _RegisterPhotoPageState extends ConsumerState<RegisterPhotoPage> {
  File? _image;

  ///  true solo si hay cámara (Android/iOS)
  bool get _hasCamera => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> _pickImage(ImageSource src) async {
    final picked = await ImagePicker().pickImage(
      source: src,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _uploadPhoto() async {
    final uri = Uri.parse(
      'http://10.100.0.12/reforma360_api/upload_profile_photo.php',
    );
    final req = http.MultipartRequest('POST', uri)
      ..fields['id'] = widget.userId.toString();

    if (_image != null) {
      req.files.add(
        await http.MultipartFile.fromPath('profile_image', _image!.path),
      );
    }

    final res = await req.send();
    final body = await res.stream.bytesToString();
    final ok = body.contains('"success":true');

    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error subiendo foto')));
      return;
    }
  }

  /// 1) Sube (o confirma) la foto · 2) Login automático · 3) Home
  Future<void> _continue() async {
    await _uploadPhoto();

    // ——— LOGIN AUTOMÁTICO ———
    await ref.read(
      loginProvider(
        LoginRequest(email: widget.email, password: widget.password).toJson(),
      ).future,
    );

    // Con el loginProvider ya se ha rellenado userProvider → no hay redirect
    context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tu foto de perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Vista previa
            if (_image != null)
              CircleAvatar(radius: 60, backgroundImage: FileImage(_image!))
            else
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/user.jpg'),
              ),

            const SizedBox(height: 24),

            // Botones galería / cámara
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                if (_hasCamera)
                  IconButton(
                    icon: const Icon(Icons.photo_camera),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
              ],
            ),

            const Spacer(),

            // Continuar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _continue,
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
