import 'package:flutter/material.dart';
import 'package:inventivo_viveros/models/planta_model.dart';
import 'package:inventivo_viveros/services/planta_service.dart';

class AgregarPlantaScreen extends StatefulWidget {
  final VoidCallback? onGuardado;

  const AgregarPlantaScreen({super.key, this.onGuardado});

  @override
  State<AgregarPlantaScreen> createState() => _AgregarPlantaScreenState();
}

class _AgregarPlantaScreenState extends State<AgregarPlantaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PlantasService();
  bool _isSaving = false;

  final _nameCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _bagCtrl = TextEditingController();
  final _cantidadCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _estadoCtrl = TextEditingController(text: 'Disponible');

  Future<void> _guardarPlanta() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final planta = Planta(
        id: 0,
        nameplants: _nameCtrl.text.trim(),
        typeplants: _typeCtrl.text.trim(),
        numberbag: _bagCtrl.text.trim(),
        cantidad: int.parse(_cantidadCtrl.text),
        price: double.parse(_priceCtrl.text),
        estado: _estadoCtrl.text.trim(),
      );

      final ok = await _service.agregarPlanta(planta);

      setState(() => _isSaving = false);

      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Planta agregada correctamente')),
        );
        widget.onGuardado?.call();
        _nameCtrl.clear();
        _typeCtrl.clear();
        _bagCtrl.clear();
        _cantidadCtrl.clear();
        _priceCtrl.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🚨 La planta ya existe o ocurrió un error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5E3), // color de fondo similar al diseño
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🏷️ Título principal
                const Text(
                  'Agregar Planta',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // 🔍 Barra de búsqueda
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📋 Contenedor principal de los campos
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 📦 Filas dobles de campos
                      Row(
                        children: [
                          Expanded(child: _buildInputTile(Icons.local_florist, "Nombre del producto", _nameCtrl, "Rosas")),
                          const SizedBox(width: 26),
                          Expanded(child: _buildInputTile(Icons.shopping_bag, "Número de bolsa", _bagCtrl, "35")),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(child: _buildInputTile(Icons.category, "Categoría", _typeCtrl, "Ornamentales")),
                          const SizedBox(width: 26),
                          Expanded(child: _buildInputTile(Icons.attach_money, "Precio Unitario", _priceCtrl, "\$6.000")),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(child: _buildInputTile(Icons.eco, "Total de plantas", _cantidadCtrl, "148")),
                          const SizedBox(width: 26),
                          Expanded(child: _buildInputTile(Icons.eco_outlined, "Estado", _estadoCtrl, "Disponible")),
                        ],
                      ),

                      const SizedBox(height: 34),

                      // 🌿 Botón para agregar producto
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _guardarPlanta,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E6B3F),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'Agregar productos',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🌱 Tarjeta para cada campo con ícono y texto
  Widget _buildInputTile(IconData icon, String label, TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E6B3F), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
                hintText: hint,
                border: InputBorder.none,
              ),
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
          ),
        ],
      ),
    );
  }
}
