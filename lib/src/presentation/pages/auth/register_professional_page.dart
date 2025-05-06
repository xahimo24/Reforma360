// lib/src/presentation/pages/auth/register_professional_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../core/routes/route_names.dart';

class RegisterProfessionalPage extends StatefulWidget {
  final int userId;
  final String email;
  final String password;

  const RegisterProfessionalPage({
    Key? key,
    required this.userId,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _RegisterProfessionalPageState createState() =>
      _RegisterProfessionalPageState();
}

class _RegisterProfessionalPageState extends State<RegisterProfessionalPage> {
  final _formKey = GlobalKey<FormState>();
  final _catCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitProf() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final res = await http.post(
      Uri.parse('http://10.100.0.12/reforma360_api/create_professional.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': widget.userId,
        'categoria': _catCtrl.text.trim(),
        'experiencia': int.parse(_expCtrl.text.trim()),
        'descripcion': _descCtrl.text.trim(),
        'ciudad': _cityCtrl.text.trim(),
      }),
    );

    final data = jsonDecode(res.body);
    final ok = res.statusCode == 200 && data['success'] == true;

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profesional registrado')));

      // ——→ Paso 3: foto (con credenciales para login automático)
      context.go(
        RouteNames.registerPhoto,
        extra: {
          'userId': widget.userId,
          'isProfessional': true,
          'email': widget.email,
          'password': widget.password,
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'] ?? 'Error')));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos de Profesional')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _catCtrl,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (v) => v!.isNotEmpty ? null : 'Requerido',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _expCtrl,
                decoration: const InputDecoration(
                  labelText: 'Años de experiencia',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (v) =>
                        (v != null && int.tryParse(v) != null)
                            ? null
                            : 'Número válido',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (v) => v!.isNotEmpty ? null : 'Requerido',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityCtrl,
                decoration: const InputDecoration(labelText: 'Ciudad'),
                validator: (v) => v!.isNotEmpty ? null : 'Requerido',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitProf,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Finalizar registro'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
