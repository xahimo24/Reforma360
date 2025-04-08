import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_names.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
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
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
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
    );
  }
}
