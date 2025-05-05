// lib/src/presentation/pages/auth/register_photo_page.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../core/routes/route_names.dart';

class RegisterPhotoPage extends StatefulWidget {
  final int userId; // ID recién creado
  final bool isProfessional; // si hay que seguir al paso 3

  const RegisterPhotoPage({
    Key? key,
    required this.userId,
    required this.isProfessional,
  }) : super(key: key);

  @override
  _RegisterPhotoPageState createState() => _RegisterPhotoPageState();
}

class _RegisterPhotoPageState extends State<RegisterPhotoPage> {
  File? _image;

  Future<void> _pickImage(ImageSource src) async {
    final pic = await ImagePicker().pickImage(
      source: src,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pic != null) setState(() => _image = File(pic.path));
  }

  Future<void> _uploadAndContinue() async {
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
    final data = body.contains('"success":true');

    if (data) {
      if (widget.isProfessional) {
        // vamos al formulario profesional
        context.go(RouteNames.registerProfessional, extra: widget.userId);
      } else {
        // fin: vamos al login o home
        context.go(RouteNames.login);
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error subiendo foto')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tu foto de perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_image != null)
              CircleAvatar(radius: 60, backgroundImage: FileImage(_image!))
            else
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/default_user.png'),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                if (!kIsWeb)
                  IconButton(
                    icon: const Icon(Icons.photo_camera),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _uploadAndContinue,
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
