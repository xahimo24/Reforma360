import 'dart:convert'; // Para jsonDecode
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/auth/user_model.dart';
import '../../providers/auth/auth_provider.dart';
import '../../../core/routes/route_names.dart';

/// Página para editar el perfil del usuario, con actualización real en servidor
/// y eliminación de cuenta con verificación de contraseña.
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _apellidosCtrl;
  late final TextEditingController _telefonoCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _bioCtrl;

  File? _profileImage; // Imagen seleccionada localmente
  bool _isSaving = false; // Indicador de envío en curso

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider)!;
    _nombreCtrl = TextEditingController(text: user.nom);
    _apellidosCtrl = TextEditingController(text: user.cognoms);
    _telefonoCtrl = TextEditingController(text: user.telefon);
    _emailCtrl = TextEditingController(text: user.email);
    _bioCtrl = TextEditingController(text: user.bio ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidosCtrl.dispose();
    _telefonoCtrl.dispose();
    _emailCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // SELECCIÓN / CAPTURA DE FOTO DE PERFIL
  // -------------------------------------------------------------------------
  Future<void> _changeProfilePhoto() async {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Wrap(
              children: [
                // Opción Galería siempre disponible
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Seleccionar de galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickProfileImage();
                  },
                ),
                // Opción Cámara solo si no es Web y el dispositivo la soporta
                if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Tomar foto'),
                    onTap: () {
                      Navigator.pop(context);
                      _takeProfilePhoto();
                    },
                  ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  Future<void> _takeProfilePhoto() async {
    final picker = ImagePicker();
    final taken = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (taken != null) {
      setState(() => _profileImage = File(taken.path));
    }
  }

  // -------------------------------------------------------------------------
  // LLAMADA AL ENDPOINT PHP update_profile.php
  // -------------------------------------------------------------------------
  Future<bool> _updateProfileOnServer(int userId) async {
    final uri = Uri.parse(
      'http://10.100.0.12/reforma360_api/update_profile.php',
    );
    final request =
        http.MultipartRequest('POST', uri)
          ..fields['id'] = userId.toString()
          ..fields['nom'] = _nombreCtrl.text
          ..fields['cognoms'] = _apellidosCtrl.text
          ..fields['telefon'] = _telefonoCtrl.text
          ..fields['email'] = _emailCtrl.text
          ..fields['bio'] = _bioCtrl.text;
    // Si hay nueva imagen, la subimos
    if (_profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_image', _profileImage!.path),
      );
    }
    final streamed = await request.send();
    final respStr = await streamed.stream.bytesToString();
    final data = jsonDecode(respStr);
    return data['success'] == true;
  }

  // -------------------------------------------------------------------------
  // GUARDAR CAMBIOS
  // -------------------------------------------------------------------------
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final user = ref.read(userProvider)!;
      final ok = await _updateProfileOnServer(user.id);
      if (!ok) throw Exception('Servidor rechazó los cambios');

      // Actualizar provider localmente
      ref.read(userProvider.notifier).state = UserModel(
        id: user.id,
        nom: _nombreCtrl.text,
        cognoms: _apellidosCtrl.text,
        email: _emailCtrl.text,
        telefon: _telefonoCtrl.text,
        tipus: user.tipus,
        foto:
            _profileImage != null
                ? 'media/profile/${user.id}.jpg' // ruta relativa a servidor
                : user.foto,
        bio: _bioCtrl.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );
      context.go(RouteNames.profile);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // -------------------------------------------------------------------------
  // LLAMADA AL ENDPOINT PHP delete_account.php
  // -------------------------------------------------------------------------
  Future<bool> _deleteAccountOnServer(int userId, String password) async {
    final uri = Uri.parse(
      'http://10.100.0.12/reforma360_api/delete_account.php',
    );
    final response = await http.post(
      uri,
      body: {'id': userId.toString(), 'password': password},
    );
    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  // -------------------------------------------------------------------------
  // DIÁLOGO DE CONFIRMACIÓN CON CONTRASEÑA
  // -------------------------------------------------------------------------
  Future<void> _deleteAccount() async {
    final user = ref.read(userProvider)!;
    String pwd = '';
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Eliminar cuenta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Para confirmar, introduce tu contraseña:'),
                const SizedBox(height: 8),
                TextField(
                  obscureText: true,
                  onChanged: (v) => pwd = v,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
    if (confirm != true) return;
    // Intentar eliminar en servidor
    final ok = await _deleteAccountOnServer(user.id, pwd);
    if (ok) {
      ref.read(userProvider.notifier).state = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      context.go(RouteNames.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña incorrecta o error del servidor'),
        ),
      );
    }
  }

  // -------------------------------------------------------------------------
  // BUILD: Estructura de UI completa, con avatar, formulario y botones
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final theme = Theme.of(context);

    // URL de avatar en servidor
    final networkAvatar =
        user.foto.isNotEmpty
            ? NetworkImage('http://10.100.0.12/reforma360_api/${user.foto}')
            : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.profile),
        ),
        title: Text(user.nom),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // Avatar con opción de cambiar
            GestureDetector(
              onTap: _changeProfilePhoto,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    _profileImage != null
                        ? FileImage(_profileImage!)
                        : networkAvatar,
                child:
                    (_profileImage == null && networkAvatar == null)
                        ? const Icon(Icons.person, size: 60)
                        : null,
              ),
            ),
            const SizedBox(height: 24),

            // Botón cambiar contraseña
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go(RouteNames.changePassword),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Cambiar contraseña'),
              ),
            ),
            const SizedBox(height: 24),

            // Formulario de datos
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildField(_nombreCtrl, 'Nombre'),
                  const SizedBox(height: 12),
                  _buildField(_apellidosCtrl, 'Apellidos'),
                  const SizedBox(height: 12),
                  _buildField(
                    _telefonoCtrl,
                    'Teléfono',
                    keyboard: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    _emailCtrl,
                    'Correo electrónico',
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _buildField(_bioCtrl, 'Biografía', maxLines: 3),
                  const SizedBox(height: 24),

                  // Guardar cambios
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                          _isSaving
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Guardar cambios'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Eliminar cuenta
                  TextButton(
                    onPressed: _deleteAccount,
                    child: const Text(
                      'Elimina tu cuenta aquí.',
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Campo de texto reutilizable con validación básica
  Widget _buildField(
    TextEditingController ctrl,
    String label, {
    bool obscure = false,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'El campo $label es obligatorio';
        return null;
      },
    );
  }
}
