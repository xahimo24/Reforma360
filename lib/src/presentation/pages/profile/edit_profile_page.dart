import 'dart:convert'; // Para jsonDecode
import 'dart:io'; // Para File y Platform
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/auth/user_model.dart';
import '../../providers/auth/auth_provider.dart';
import '../../../core/routes/route_names.dart';
import '../../providers/professionals/professionals_provider.dart'; // Añade este import
import '../../providers/professionals/categories_provider.dart';
import '../../../data/models/professional_model.dart'; // Añade este import

final List<String> _ciudades = [
  '', 'Álava', 'Albacete', 'Alicante', 'Almería', 'Asturias', 'Ávila', 'Badajoz', 'Barcelona',
  'Burgos', 'Cáceres', 'Cádiz', 'Cantabria', 'Castellón', 'Ciudad Real', 'Córdoba', 'Cuenca',
  'Gerona', 'Granada', 'Guadalajara', 'Guipúzcoa', 'Huelva', 'Huesca', 'Islas Baleares', 'Jaén',
  'La Coruña', 'La Rioja', 'Las Palmas', 'León', 'Lérida', 'Lugo', 'Madrid', 'Málaga', 'Murcia',
  'Navarra', 'Orense', 'Palencia', 'Pontevedra', 'Salamanca', 'Santa Cruz de Tenerife', 'Segovia',
  'Sevilla', 'Soria', 'Tarragona', 'Teruel', 'Toledo', 'Valencia', 'Valladolid', 'Vizcaya',
  'Zamora', 'Zaragoza', 'Ceuta', 'Melilla',
];

/// Página para editar el perfil del usuario,
/// con actualización real en servidor y eliminación de cuenta.
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
  late TextEditingController? _categoryCtrl;
  late TextEditingController? _experienceCtrl;
  late TextEditingController? _cityCtrl;
  late TextEditingController? _descriptionCtrl;

  int? _selectedCategoryId;
  String? _selectedCity;

  File? _profileImage; // Imagen: File local si se cambia
  bool _isSaving = false; // Indicador de carga

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider)!;
    _nombreCtrl = TextEditingController(text: user.nom);
    _apellidosCtrl = TextEditingController(text: user.cognoms);
    _telefonoCtrl = TextEditingController(text: user.telefon);
    _emailCtrl = TextEditingController(text: user.email);
    _bioCtrl = TextEditingController(text: user.bio ?? '');

    if (user.tipus == true) {
      // Busca el profesional del usuario
      ref.read(professionalsProvider('')).whenData((profs) {
        final prof = profs.firstWhere(
          (p) => p.userId == user.id,
          orElse: () => ProfessionalModel(
            id: 0,
            userId: user.id,
            userName: '',
            userAvatar: '',
            categoryId: 0,
            categoryName: '',
            experience: 0,
            city: '',
            description: '',
            avgRating: 0.0,
            reviewsCount: 0,
          ),
        );
        setState(() {
          _selectedCategoryId = prof.categoryId != 0 ? prof.categoryId : null;
          _experienceCtrl = TextEditingController(text: prof.experience.toString());
          _selectedCity = _ciudades.contains(prof.city) ? prof.city : '';
          _descriptionCtrl = TextEditingController(text: prof.description);
        });
      });
    } else {
      _categoryCtrl = null;
      _experienceCtrl = null;
      _cityCtrl = null;
      _descriptionCtrl = null;
    }
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

  //───────────────────────────────────────────────────────────────────────────
  // Elegir o tomar foto de perfil
  //───────────────────────────────────────────────────────────────────────────
  Future<void> _changeProfilePhoto() async {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Wrap(
              children: [
                // Opción: galería
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Seleccionar de galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickProfileImage();
                  },
                ),
                // Opción: cámara (solo Android/iOS)
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

  //───────────────────────────────────────────────────────────────────────────
  // Enviar cambios al servidor (update_profile.php)
  //───────────────────────────────────────────────────────────────────────────
  Future<bool> _updateProfileOnServer(int userId) async {
    final uri = Uri.parse(
      'http://10.100.0.12/reforma360_api/update_profile.php',
    );
    final req =
        http.MultipartRequest('POST', uri)
          ..fields['id'] = userId.toString()
          ..fields['nom'] = _nombreCtrl.text
          ..fields['cognoms'] = _apellidosCtrl.text
          ..fields['telefon'] = _telefonoCtrl.text
          ..fields['email'] = _emailCtrl.text
          ..fields['bio'] = _bioCtrl.text;

    // Adjuntar campos profesionales si corresponde
    final user = ref.read(userProvider)!;
    if (user.tipus && _categoryCtrl != null) {
      req.fields['category'] = _categoryCtrl!.text;
      req.fields['experience'] = _experienceCtrl!.text;
      req.fields['city'] = _cityCtrl!.text;
      req.fields['description'] = _descriptionCtrl!.text;
    }

    // Adjuntar nueva foto si hay
    if (_profileImage != null) {
      req.files.add(
        await http.MultipartFile.fromPath('profile_image', _profileImage!.path),
      );
    }
    final streamed = await req.send();
    final body = await streamed.stream.bytesToString();
    final data = jsonDecode(body);
    return data['success'] == true;
  }

  Future<bool> _updateProfessionalOnServer(int userId) async {
    final uri = Uri.parse('http://10.100.0.12/reforma360_api/update_professional.php');
    final resp = await http.post(
      uri,
      body: {
        'user_id': userId.toString(),
        'category': _selectedCategoryId?.toString() ?? '',
        'experience': _experienceCtrl?.text ?? '',
        'city': _selectedCity ?? '',
        'description': _descriptionCtrl?.text ?? '',
      },
    );
    final data = jsonDecode(resp.body);
    return data['success'] == true;
  }

  //───────────────────────────────────────────────────────────────────────────
  // Guardar cambios (nombre, apellidos, email, teléfono, bio, foto)
  //───────────────────────────────────────────────────────────────────────────
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final user = ref.read(userProvider)!;
      final ok = await _updateProfileOnServer(user.id);
      if (!ok) throw Exception('Servidor rechazó cambios');

      // Si es profesional, actualiza también los datos profesionales
      if (user.tipus && _categoryCtrl != null) {
        final okProf = await _updateProfessionalOnServer(user.id);
        if (!okProf) throw Exception('Error al guardar datos profesionales');
      }

      // Actualizar estado local
      ref.read(userProvider.notifier).state = UserModel(
        id: user.id,
        nom: _nombreCtrl.text,
        cognoms: _apellidosCtrl.text,
        email: _emailCtrl.text,
        telefon: _telefonoCtrl.text,
        tipus: user.tipus,
        foto: _profileImage != null
            ? 'media/profile/${user.id}.${_profileImage!.path.split('.').last}'
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

  //───────────────────────────────────────────────────────────────────────────
  // Eliminar cuenta con confirmación de contraseña
  //───────────────────────────────────────────────────────────────────────────
  Future<bool> _deleteAccountOnServer(int userId, String password) async {
    final uri = Uri.parse(
      'http://10.100.0.12/reforma360_api/delete_account.php',
    );
    final resp = await http.post(
      uri,
      body: {'id': userId.toString(), 'password': password},
    );
    final data = jsonDecode(resp.body);
    return data['success'] == true;
  }

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

  //───────────────────────────────────────────────────────────────────────────
  // Construcción de la UI
  //───────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final theme = Theme.of(context);

    // URL completa del avatar en servidor
    final networkAvatar =
        user.foto.isNotEmpty
            ? NetworkImage('http://10.100.0.12/reforma360_api/${user.foto}')
            : null;

    return Scaffold(
      // AppBar con botón atrás
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

      // Cuerpo scrollable con avatar, botón y formulario
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // Avatar (Network o File) + toque para cambiar
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

            // Formulario de datos: nombre, apellidos, teléfono, email, bio
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
                  _buildField(
                    _bioCtrl,
                    'Biografía',
                    maxLines: 3,
                    required: false,
                  ),
                  const SizedBox(height: 12),

                  if (user.tipus) ...[
                    Consumer(
                      builder: (context, ref, _) {
                        final categoriesAsync = ref.watch(categoriesProvider);
                        return categoriesAsync.when(
                          data: (categories) => DropdownButtonFormField<int>(
                            value: _selectedCategoryId,
                            decoration: const InputDecoration(
                              labelText: 'Categoría',
                              border: OutlineInputBorder(),
                              filled: true,
                            ),
                            items: [
                              const DropdownMenuItem<int>(
                                value: null,
                                child: Text('Sin categoría'),
                              ),
                              ...categories.map<DropdownMenuItem<int>>((cat) => DropdownMenuItem<int>(
                                    value: cat['id'] as int,
                                    child: Text(cat['nombre']),
                                  ))
                            ],
                            onChanged: (val) {
                              setState(() {
                                _selectedCategoryId = val;
                              });
                            },
                            validator: (val) => (val == null) ? 'Selecciona una categoría' : null,
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (e, _) => Text('Error al cargar categorías: $e'),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildField(_experienceCtrl!, 'Años de experiencia', keyboard: TextInputType.number),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      items: _ciudades
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.isEmpty ? 'Todas' : c),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCity = val;
                        });
                      },
                      validator: (val) => (val == null || val.isEmpty) ? 'Selecciona una ciudad' : null,
                    ),
                    const SizedBox(height: 12),

                    _buildField(_descriptionCtrl!, 'Descripción', maxLines: 3, required: false),
                    const SizedBox(height: 24),
                  ],

                  // Botón Guardar cambios
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                          _isSaving
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Guardar cambios'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón Cambiar Contraseña, pasando el email como extra
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed:
                          () => context.go(
                            RouteNames.changePassword,
                            extra: user.email, // ← se envía el email aquí
                          ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cambiar contraseña'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Enlace para eliminar cuenta
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

  /// Campo de texto reutilizable con validación obligatoria
  Widget _buildField(
    TextEditingController ctrl,
    String label, {
    bool obscure = false,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    bool required = true,
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
      ),
      validator:
          (val) =>
              required && (val == null || val.isEmpty)
                  ? 'El campo $label es obligatorio'
                  : null,
    );
  }
}
