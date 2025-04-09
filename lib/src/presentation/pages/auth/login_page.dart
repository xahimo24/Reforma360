import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- Import
import '../../../data/models/auth/user_model.dart';
import '../../providers/auth/auth_provider.dart';
import '../../../core/routes/route_names.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final credentials = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      try {
        // 1) Llamamos al loginProvider para hacer login en el backend
        final user = await ref.read(loginProvider(credentials).future);

        // 2) Guardamos el usuario en SharedPreferences
        await _saveUserSession(user);

        // 3) Mostramos snackbar de bienvenida
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bienvenido, ${user.nom}')));

        // 4) Redirigimos a Home
        context.go(RouteNames.home);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
      }
    }
  }

  // Función para guardar la sesión del usuario en SharedPreferences
  Future<void> _saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // Guarda los campos que necesites. Ejemplo:
    prefs.setInt('userId', user.id);
    prefs.setString('nom', user.nom);
    prefs.setString('cognoms', user.cognoms);
    prefs.setString('email', user.email);
    prefs.setString('telefon', user.telefon);
    // 'tipus' lo guardamos como bool, si te interesa
    prefs.setBool('tipus', user.tipus);
    // 'foto' si lo usas
    prefs.setString('foto', user.foto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Reforma360',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Inspírate y reforma'),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Introduce tu email'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Introduce tu contraseña'
                              : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go(RouteNames.register),
                  child: const Text('Regístrate'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go(RouteNames.recoverPassword),
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
