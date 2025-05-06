import 'package:flutter/material.dart';

class ProcessingPage extends StatelessWidget {
  final String professionalName;

  const ProcessingPage({Key? key, required this.professionalName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Asegura fondo blanco
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        title: Text('Tramitación con $professionalName'),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                _buildListTile('DIRECCIÓN', 'Añade una dirección', onTap: () {
                  // Abrir selector de dirección
                }),
                _buildListTile('PLAZO DE CONTACTO', 'ESTÁNDAR | 3 – 4 días\nPREMIUM | 24 – 48 horas'),
                _buildListTile('MÉTODO DE PAGO', 'Visa *1234'),
                _buildListTile('PROMOS', 'Aplicar código promocional'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Text('ELEMENTOS', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                _buildElementTile('Mantenimiento', Icons.construction),
                _buildImageElementTile('Cambio de racholas', 'assets/images/racholas.jpg'),
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
                  // Acción al pedir presupuesto
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'PEDIR PRESUPUESTO',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ListTile general con opción de onTap
  Widget _buildListTile(String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildElementTile(String description, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 40),
      title: Text(description),
    );
  }

  Widget _buildImageElementTile(String description, String imagePath) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
      ),
      title: Text(description),
    );
  }
}
