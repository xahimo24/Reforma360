import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/auth/user_model.dart';
import '../../providers/auth/auth_provider.dart';
import '../../../core/routes/route_names.dart';


class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidosCtrl;
  late TextEditingController _telefonoCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _confirmPasswordCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider)!;
    _nombreCtrl = TextEditingController(text: user.nom);
    _apellidosCtrl = TextEditingController(text: user.cognoms);
    _telefonoCtrl = TextEditingController(text: user.telefon);
    _emailCtrl = TextEditingController(text: user.email);
    _passwordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidosCtrl.dispose();
    _telefonoCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordCtrl.text.isNotEmpty &&
        _passwordCtrl.text != _confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      // TODO: Llamar a tu API de actualización:
      // await ref.read(authRepositoryProvider).updateProfile(
      //   id: user.id,
      //   nombre: _nombreCtrl.text,
      //   ...
      // );
      await Future.delayed(const Duration(seconds: 1)); // simulación

      // Actualizar provider localmente
      final old = ref.read(userProvider)!;
      ref.read(userProvider.notifier).state = UserModel(
        id: old.id,
        nom: _nombreCtrl.text,
        cognoms: _apellidosCtrl.text,
        email: _emailCtrl.text,
        telefon: _telefonoCtrl.text,
        tipus: old.tipus,
        foto: old.foto,
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

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Eliminar cuenta'),
            content: const Text('¿Estás seguro de eliminar tu cuenta?'),
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

    // TODO: llamar a API de borrado
    // await ref.read(authRepositoryProvider).deleteAccount(user.id);
    // simulación:
    await Future.delayed(const Duration(seconds: 1));

    // Limpiar sesión y prefs
    ref.read(userProvider.notifier).state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Volver a login
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.profile),
        ),
        centerTitle: true,
        title: Text(user.nom),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  user.foto.isNotEmpty ? NetworkImage(user.foto) : null,
              child:
                  user.foto.isEmpty ? const Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 24),

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
                  _buildField(_passwordCtrl, 'Contraseña', obscure: true),
                  const SizedBox(height: 12),
                  _buildField(
                    _confirmPasswordCtrl,
                    'Repite la contraseña',
                    obscure: true,
                  ),
                  const SizedBox(height: 24),
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

  Widget _buildField(
    TextEditingController ctrl,
    String label, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboard,
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
