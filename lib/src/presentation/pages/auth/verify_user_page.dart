import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'change_password_page.dart'; // Importa la página para cambiar la contraseña

class VerifyUserPage extends StatefulWidget {
  const VerifyUserPage({Key? key}) : super(key: key);

  @override
  _VerifyUserPageState createState() => _VerifyUserPageState();
}

class _VerifyUserPageState extends State<VerifyUserPage> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _verifyUser() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    setState(() => _isLoading = true);

    try {
      // Realiza la solicitud al backend para verificar los datos del usuario
      final response = await http.post(
        Uri.parse('http://10.100.0.12/reforma360_api/verify-user.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'phone': phone}),
      );

      if (response.statusCode == 200) {
        // Éxito: Navega a la página de cambiar contraseña
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordPage(email: email),
          ),
        );
      } else {
        // Error del servidor
        final error = jsonDecode(response.body)['message'] ?? 'Error desconocido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } catch (e) {
      // Error de red u otro problema
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Introduce tu correo electrónico y teléfono para verificar tu identidad.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu correo electrónico.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Introduce un correo electrónico válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu número de teléfono.';
                  }
                  if (!RegExp(r'^\d{9}$').hasMatch(value)) {
                    return 'Introduce un número de teléfono válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text('Verificar Usuario'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}