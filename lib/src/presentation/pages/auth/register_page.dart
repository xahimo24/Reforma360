import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Ajusta si usas Navigator
import '../../providers/auth/auth_provider.dart';
import '../../../data/models/auth/register_request.dart';
import '../../../core/routes/route_names.dart';

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

  bool _isProfessional = false;

  // Método para validar contraseñas
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce una contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Comprueba que ambas contraseñas coinciden
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Repite la contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _submit() async {
    // Valida todos los campos del formulario
    if (_formKey.currentState!.validate()) {
      final request = RegisterRequest(
        nom: _nomController.text,
        cognoms: _cognomsController.text,
        email: _emailController.text,
        password: _passwordController.text,
        telefon: _telefonController.text,
        tipus: _isProfessional,
        foto: 'default.jpg',
      );

      try {
        // Llamamos a registerProvider
        final result = await ref.read(registerProvider(request).future);

        if (result) {
          // MOSTRAR SNACKBAR
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Registro completado')));

          // [1] OPCIÓN: Actualizar userProvider con los datos, si quieres
          // TODO: Si el backend te devuelve el user, guardalo en userProvider

          // [2] Redirigir a la HOME con sesión iniciada
          context.go(RouteNames.home);
          // O Navigator.pushNamed(context, '/home'); si usas Navigator
        }
      } catch (e) {
        // Muestra error si falla
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Quitamos appBar para parecerse más al diseño Figma
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado estilo Figma
                const SizedBox(height: 16),
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
                // Nombre
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Tu nombre',
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Introduce tu nombre'
                              : null,
                ),
                const SizedBox(height: 16),

                // Apellidos
                TextFormField(
                  controller: _cognomsController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos',
                    hintText: 'Tus apellidos',
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Introduce tus apellidos'
                              : null,
                ),
                const SizedBox(height: 16),

                // Teléfono (opcional)
                TextFormField(
                  controller: _telefonController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono (opcional)',
                  ),
                ),
                const SizedBox(height: 16),

                // Email
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

                // Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),

                // Repetir contraseña
                TextFormField(
                  controller: _confirmPassController,
                  decoration: const InputDecoration(
                    labelText: 'Repite la contraseña',
                  ),
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 16),

                // Switch: ¿Profesional?
                SwitchListTile(
                  title: const Text('¿Eres profesional?'),
                  value: _isProfessional,
                  onChanged: (val) => setState(() => _isProfessional = val),
                ),
                const SizedBox(height: 24),

                // Botón de Registrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Separador (línea o guion)
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

                // Botón de “¿Ya tienes cuenta? Inicia sesión”
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

                // Footer con políticas
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
