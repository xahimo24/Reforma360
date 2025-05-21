import 'dart:io';
import 'dart:convert'; // 👈 Necesario para jsonDecode

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../core/routes/route_names.dart';
import '../../providers/auth/auth_provider.dart';

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una imagen')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final user = ref.read(userProvider)!;
      final uri = Uri.parse(
        'http://10.100.0.12/reforma360_api/create_publication.php',
      );

      final request =
          http.MultipartRequest('POST', uri)
            ..fields['user_id'] = user.id.toString()
            ..fields['description'] = _descController.text
            ..files.add(
              await http.MultipartFile.fromPath('image', _imageFile!.path),
            );

      final response = await request.send();
      final body = await response.stream.bytesToString();

      // 👇 DEBUG: Ver respuesta exacta en consola
      print("Código respuesta: ${response.statusCode}");
      print("Cuerpo respuesta: $body");

      if (response.statusCode == 200) {
        final json = jsonDecode(body);
        if (json['success'] == true) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Publicación creada')));
          context.go(RouteNames.home);
        } else {
          throw Exception('Error API: ${json['message']}');
        }
      } else {
        throw Exception('HTTP error ${response.statusCode}: $body');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Publicación'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.home),
        ),
        actions: [
          IconButton(
            icon:
                _isSubmitting
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        ///color: Colors.white,
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
            // Caja de texto estilo Figma
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                ///color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu descripción...',
                    border: InputBorder.none,
                  ),
                  minLines: 3,
                  maxLines: 6,
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? 'Descripción obligatoria'
                              : null,
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                if (Platform.isAndroid || Platform.isIOS)
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
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
