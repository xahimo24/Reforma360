import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart'; // Ajusta según uses GoRouter o Navigator
import '../../../data/models/auth/user_model.dart';
import '../../providers/auth/auth_provider.dart';
import '../../../core/routes/route_names.dart';
import 'verify_user_page.dart'; // Importa la página de recuperación de contraseña

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false; // Para mostrar indicador de carga

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final credentials = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    try {
      final user = await ref.read(loginProvider(credentials).future);

      // Guardamos el user en el provider
      ref.read(userProvider.notifier).state = user;

      // Guardar en SharedPreferences si quieres persistir la sesión
      await _saveUserSession(user);

      // Ir a Home
      if (mounted) {
        context.go(RouteNames.home); // O Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      // Mostrar error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', user.id);
    prefs.setString('nom', user.nom);
    prefs.setString('cognoms', user.cognoms);
    prefs.setString('email', user.email);
    prefs.setString('telefon', user.telefon);
    prefs.setBool('tipus', user.tipus);
    prefs.setString('foto', user.foto);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // LOGO / TÍTULO
                const SizedBox(height: 48),

                // Tu logo si lo tienes con Image.asset(), de momento un placeholder
                // Si tienes un SVG, usa flutter_svg, etc.
                // Ejemplo:
                // Image.asset('assets/logo.png', height: 80),
                const Text(
                  'Reforma360',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Inspírate y reforma',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bienvenido, empieza ya a usar Reforma360',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // EMAIL
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Introduce tu email';
                    }
                    // Puedes añadir más validaciones
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // CONTRASEÑA
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Introduce tu contraseña';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                ),

                const SizedBox(height: 16),

                // Botón para recuperar contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navega a la página de recuperación de contraseña
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifyUserPage(),
                        ),
                      );
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Botón iniciar sesión
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Iniciar sesión',
                            ),
                  ),
                ),

                const SizedBox(height: 16),

                // Separador
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

                // Botón "Regístrate"
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go(RouteNames.register),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Regístrate'),
                  ),
                ),

                const SizedBox(height: 16),

                // Footer con políticas
                Text(
                  'Al hacer clic en continuar, aceptas nuestros Términos de servicio y Política de privacidad',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
