// lib/src/presentation/pages/auth/register_page.dart

import 'dart:convert'; // Para posibles decodificaciones
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Para navegación con GoRouter

import '../../providers/auth/auth_provider.dart'; // registerProvider
import '../../../data/models/auth/register_request.dart'; // RegisterRequest
import '../../../core/routes/route_names.dart'; // RouteNames

/// Pantalla de registro de usuario, paso 0 del flujo multi-step:
/// - Recoge datos de usuario
/// - Al pulsar "Regístrate", crea el usuario en el servidor
/// - Navega al paso de selección de foto
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _cognomsController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isProfessional = false; // Si marca "¿Eres profesional?"

  /// Valida que la contraseña tenga al menos 6 caracteres
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce una contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  /// Valida que ambas contraseñas coincidan
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Repite la contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  /// Envía los datos al servidor y, si tiene éxito,
  /// navega a la página de selección de foto.
  Future<void> _submit() async {
    // 1) Validar formulario
    if (!_formKey.currentState!.validate()) return;

    // 2) Construir el objeto de petición
    final request = RegisterRequest(
      nom: _nomController.text.trim(),
      cognoms: _cognomsController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      telefon: _telefonController.text.trim(),
      tipus: _isProfessional,
      foto: '/assets/images/user.jpg', // Será reemplazado en el siguiente paso
    );

    try {
      // 3) Llamada al provider de registro, devuelve el userId
      final userId = await ref.read(registerProvider(request).future);

      // 4) Feedback visual
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registro completado')));

      // 5) Navegar al paso de selección de foto
      context.go(
        _isProfessional
            ? RouteNames.registerProfessional
            : RouteNames.registerPhoto,
        extra: {'userId': userId, 'isProfessional': _isProfessional},
      );
    } catch (e) {
      // 6) Mostrar error en caso de fallo
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Sin AppBar para ajustarse al diseño Figma
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Título principal
                Center(
                  child: Text(
                    'Reforma360',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Inspírate y reforma',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Regístrate en menos de 1 minuto',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),

                // Campo Nombre
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Tu nombre',
                  ),
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Introduce tu nombre'
                              : null,
                ),
                const SizedBox(height: 16),

                // Campo Apellidos
                TextFormField(
                  controller: _cognomsController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos',
                    hintText: 'Tus apellidos',
                  ),
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Introduce tus apellidos'
                              : null,
                ),
                const SizedBox(height: 16),

                // Campo Teléfono
                TextFormField(
                  controller: _telefonController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Introduce tu número de teléfono'
                              : null,
                ),
                const SizedBox(height: 16),

                // Campo Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    hintText: 'ejemplo@correo.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce tu email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Introduce un email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),

                // Campo Repetir Contraseña
                TextFormField(
                  controller: _confirmPassController,
                  decoration: const InputDecoration(
                    labelText: 'Repite la contraseña',
                  ),
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 16),

                // Switch “¿Eres profesional?”
                SwitchListTile(
                  title: const Text('¿Eres profesional?'),
                  value: _isProfessional,
                  onChanged: (val) => setState(() => _isProfessional = val),
                ),
                const SizedBox(height: 24),

                // Botón Registrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Regístrate',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Separador “o”
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('o'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Botón “¿Ya tienes cuenta? Inicia sesión”
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go(RouteNames.login),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                ),
                const SizedBox(height: 16),

                // Footer términos y privacidad
                Center(
                  child: Text(
                    'Al hacer clic en continuar, aceptas nuestros Términos de servicio y Política de privacidad',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
