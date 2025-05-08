import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProcessingPage extends StatefulWidget {
  final String professionalName;
  final String categoria;

  const ProcessingPage({
    Key? key,
    required this.professionalName,
    required this.categoria,
  }) : super(key: key);

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  String address = '';
  String? contactDeadline;
  String paymentMethod = '';
  String promoCode = '';
  bool promoValid = false;

  List<Map<String, String>> availableTasks = [];
  Set<String> selectedTasks = {};

  @override
  void initState() {
    super.initState();
    _loadTasks(widget.categoria);
  }

  Future<void> _loadTasks(String categoria) async {
    final response = await http.post(
      Uri.parse('http://10.100.0.12/reforma360_api/get_task_by_category.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'categoria': categoria}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        setState(() {
          availableTasks = List<Map<String, String>>.from(
            data['tareas'].map((t) => {
              'nom': t['nom'],
              'descripcio': t['descripcio'],
            }),
          );
        });
      }
    }
  }

  Future<void> _validatePromo(String promo) async {
    final response = await http.post(
      Uri.parse('http://10.100.0.12/reforma360_api/check_promo.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'promo': promo}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        promoCode = promo;
        promoValid = data['success'] == true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        title: Text('Tramitación con ${widget.professionalName}'),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                _buildListTile(
                  'DIRECCIÓN',
                  address.isEmpty ? 'Añade una dirección' : address,
                  onTap: _showAddressDialog,
                ),
                _buildListTile(
                  'PLAZO DE CONTACTO',
                  contactDeadline ?? 'Selecciona una opción',
                  onTap: _showDeadlineSelector,
                ),
                _buildListTile(
                  'MÉTODO DE PAGO',
                  paymentMethod.isEmpty ? 'Añade método de pago' : paymentMethod,
                  onTap: _showPaymentDialog,
                ),
                _buildListTile(
                  'PROMOS',
                  promoCode.isEmpty
                      ? 'Aplicar código promocional'
                      : promoValid
                          ? '$promoCode (válido)'
                          : '$promoCode (inválido)',
                  onTap: _showPromoDialog,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Text('ELEMENTOS', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...availableTasks.map(
                  (task) => ListTile(
                    leading: Icon(
                      selectedTasks.contains(task['nom'])
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: selectedTasks.contains(task['nom']) ? Colors.green : null,
                    ),
                    title: Text(task['nom'] ?? ''),
                    subtitle: Text(task['descripcio'] ?? ''),
                    onTap: () {
                      setState(() {
                        final taskName = task['nom']!;
                        if (selectedTasks.contains(taskName)) {
                          selectedTasks.remove(taskName);
                        } else {
                          selectedTasks.add(taskName);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'El profesional se pondrá en contacto contigo para acordar el presupuesto',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('Dirección: $address');
                  print('Plazo de contacto: $contactDeadline');
                  print('Método de pago: $paymentMethod');
                  print('Promo: $promoCode (válido: $promoValid)');
                  print('Tareas seleccionadas: $selectedTasks');
                  // Aquí podrías llamar a un endpoint para guardar la solicitud.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('PEDIR PRESUPUESTO', style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _showAddressDialog() async {
    final controller = TextEditingController(text: address);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Introduce dirección'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Calle, número, ciudad...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
    if (result != null && result.length >= 5) setState(() => address = result);
  }

  Future<void> _showDeadlineSelector() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => ListView(
        children: [
          ListTile(title: const Text('ESTÁNDAR | 3 – 4 días'), onTap: () => Navigator.pop(context, 'ESTÁNDAR | 3 – 4 días')),
          ListTile(title: const Text('PREMIUM | 24 – 48 horas'), onTap: () => Navigator.pop(context, 'PREMIUM | 24 – 48 horas')),
        ],
      ),
    );
    if (result != null) setState(() => contactDeadline = result);
  }

  Future<void> _showPaymentDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir método de pago'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 16,
          decoration: const InputDecoration(hintText: 'Número de tarjeta'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.length == 16) {
                Navigator.pop(context, 'Visa *${controller.text.substring(12)}');
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (result != null) setState(() => paymentMethod = result);
  }

  Future<void> _showPromoDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Código promocional'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Ej: DESCUENTO10'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim().toUpperCase()),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
    if (result != null) {
      await _validatePromo(result);
    }
  }
}
