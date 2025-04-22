import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_names.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/publicacions/create_publication_provider.dart';
import '../../../data/models/publicacio_model.dart';

class NewPostPage extends ConsumerStatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends ConsumerState<NewPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  File? _imageFile;
  Uint8List? _webImage;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      );
      if (result != null && result.files.single.bytes != null) {
        setState(() => _webImage = result.files.single.bytes);
      }
    } else {
      final picker = ImagePicker();
      final pic = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (pic != null) setState(() => _imageFile = File(pic.path));
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pic = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pic != null) setState(() => _imageFile = File(pic.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null && _webImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una imagen')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final user = ref.read(userProvider)!;
      final pub = await ref.read(
        createPublicationProvider({
          'userId': user.id,
          'description': _descController.text,
          'imageFile': _imageFile!, // si es web, usa _webImage
        }).future,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Publicación creada')));
      context.go(RouteNames.home);
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
          onPressed: () => context.pop(),
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
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.check),
            onPressed: _isSubmitting ? null : _submit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu descripción...',
                    border: OutlineInputBorder(),
                  ),
                  expands: true,
                  maxLines: null,
                  validator:
                      (v) =>
                          v == null || v.isEmpty
                              ? 'Descripción obligatoria'
                              : null,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(height: 16),
              if (_imageFile != null || _webImage != null)
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child:
                      _webImage != null
                          ? Image.memory(_webImage!, fit: BoxFit.cover)
                          : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _pickImage,
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _takePhoto,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
