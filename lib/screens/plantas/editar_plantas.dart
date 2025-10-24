import 'package:flutter/material.dart';
import 'package:inventivo_viveros/models/planta_model.dart';
import 'package:inventivo_viveros/services/planta_service.dart';

class EditarPlantaScreen extends StatefulWidget {
  final Planta planta;
  final VoidCallback? onGuardado;

  const EditarPlantaScreen({
    super.key,
    required this.planta,
    this.onGuardado,
  });

  @override
  State<EditarPlantaScreen> createState() => _EditarPlantaScreenState();
}

class _EditarPlantaScreenState extends State<EditarPlantaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PlantasService();
  bool _isSaving = false;

  late TextEditingController nameCtrl;
  late TextEditingController typeCtrl;
  late TextEditingController bagCtrl;
  late TextEditingController cantidadCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController estadoCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.planta.nameplants);
    typeCtrl = TextEditingController(text: widget.planta.typeplants);
    bagCtrl = TextEditingController(text: widget.planta.numberbag);
    cantidadCtrl = TextEditingController(text: widget.planta.cantidad.toString());
    priceCtrl = TextEditingController(text: widget.planta.price.toString());
    estadoCtrl = TextEditingController(text: widget.planta.estado);
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final updatedPlanta = Planta(
        id: widget.planta.id,
        nameplants: nameCtrl.text.trim(),
        typeplants: typeCtrl.text.trim(),
        numberbag: bagCtrl.text.trim(),
        cantidad: int.tryParse(cantidadCtrl.text) ?? 0,
        price: double.tryParse(priceCtrl.text) ?? 0,
        estado: estadoCtrl.text.trim(),
      );

      final ok = await _service.editarPlanta(updatedPlanta);

      setState(() => _isSaving = false);

      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Planta actualizada correctamente')),
        );
        widget.onGuardado?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🚨 Error al actualizar la planta o ya existe')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5E3),
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
                  'Editar Planta',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // 📋 Contenedor principal
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
                      // 🧩 Filas dobles de campos
                      Row(
                        children: [
                          Expanded(child: _buildInputTile(Icons.local_florist, "Nombre del producto", nameCtrl, "Ej: Rosas")),
                          const SizedBox(width: 26),
                          Expanded(child: _buildInputTile(Icons.shopping_bag, "Número de bolsa", bagCtrl, "Ej: 35")),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(child: _buildInputTile(Icons.category, "Categoría", typeCtrl, "Ej: Ornamentales")),
                          const SizedBox(width: 26),
                          Expanded(child: _buildInputTile(Icons.attach_money, "Precio Unitario", priceCtrl, "Ej: 6000")),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(child: _buildInputTile(Icons.eco, "Total de plantas", cantidadCtrl, "Ej: 148")),
                          const SizedBox(width: 26),
                          Expanded(child: _buildInputTile(Icons.eco_outlined, "Estado", estadoCtrl, "Ej: Disponible")),
                        ],
                      ),

                      const SizedBox(height: 34),

                      // 🌿 Botón Guardar Cambios
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _guardarCambios,
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
                                  'Guardar Cambios',
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

  // 🌱 Campo con diseño unificado
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
