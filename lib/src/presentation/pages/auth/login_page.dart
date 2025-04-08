import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        final user = await ref.read(loginProvider(credentials).future);

        // Aquí puedes guardar info del usuario si quieres
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bienvenido, ${user.nom}')));

        context.go(RouteNames.home); // Redirigir a la página principal
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar sessió")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Introdueix el teu email'
                            : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contrasenya'),
                obscureText: true,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Introdueix la contrasenya'
                            : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text("Entrar")),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go(RouteNames.register),
                child: const Text("Encara no tens compte? Registra't"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
