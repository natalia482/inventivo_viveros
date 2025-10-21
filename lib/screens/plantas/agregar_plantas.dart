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
      appBar: AppBar(title: const Text('Agregar Planta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre de la planta'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _typeCtrl,
                decoration: const InputDecoration(labelText: 'Tipo de planta'),
              ),
              TextFormField(
                controller: _bagCtrl,
                decoration: const InputDecoration(labelText: 'Número de bolsa'),
              ),
              TextFormField(
                controller: _cantidadCtrl,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _estadoCtrl,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _guardarPlanta,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
