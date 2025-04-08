import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth/auth_provider.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../data/models/auth/register_request.dart';

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
  final _passwordController = TextEditingController();
  final _telefonController = TextEditingController();
  bool _isProfessional = false;

  void _submit() async {
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

      final result = await ref.read(registerProvider(request).future);
      if (result) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registro completado')));
        Navigator.pop(context); // o redirigir al login
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar-se")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextFormField(
                controller: _cognomsController,
                decoration: const InputDecoration(labelText: 'Cognoms'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _telefonController,
                decoration: const InputDecoration(labelText: 'Telèfon'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contrasenya'),
                obscureText: true,
              ),
              SwitchListTile(
                title: const Text('Ets professional?'),
                value: _isProfessional,
                onChanged: (val) => setState(() => _isProfessional = val),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
