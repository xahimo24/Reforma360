// ---------------------------------------------------------------------------
// Cambiar contraseña → tras éxito navega al perfil
// ---------------------------------------------------------------------------
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart'; // Para addPostFrameCallback
import 'package:go_router/go_router.dart';

import '../../providers/auth/auth_provider.dart';
import '../../../core/routes/route_names.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  final String? email; // opcional

  const ChangePasswordPage({Key? key, this.email}) : super(key: key);

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _newPassCtrl = TextEditingController();
  final _repeatCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _repeatCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword(String email) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final res = await http.post(
        Uri.parse('http://10.100.0.12/reforma360_api/change-password.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'newPassword': _newPassCtrl.text.trim(),
        }),
      );

      if (!mounted) return;

      if (res.statusCode == 200) {
        // Mensaje éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña cambiada correctamente')),
        );
        // En el próximo frame, ir al perfil
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => context.go(RouteNames.profile),
        );
      } else {
        final msg = jsonDecode(res.body)['message'] ?? 'Error desconocido';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $msg')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de red: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Email: parámetro o userProvider
    final email = widget.email ?? ref.read(userProvider)?.email;
    if (email == null || email.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo determinar tu correo')),
        );
        context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Introduce tu nueva contraseña.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPassCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nueva Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty)
                    return 'Introduce tu nueva contraseña.';
                  if (v.length < 6) return 'Mínimo 6 caracteres.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _repeatCtrl,
                decoration: const InputDecoration(
                  labelText: 'Repite la Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty)
                    return 'Repite tu nueva contraseña.';
                  if (v != _newPassCtrl.text)
                    return 'Las contraseñas no coinciden.';
                  return null;
                },
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : () => _changePassword(email),
                  child:
                      _loading
                          ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                          : const Text('Cambiar Contraseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
