import 'package:flutter/material.dart';
import 'package:inventivo_viveros/models/planta_model.dart';
import 'package:inventivo_viveros/services/planta_service.dart';
import 'lista_plantas.dart';

class EditarPlantaScreen extends StatefulWidget {
  final Planta planta;
  final VoidCallback? onGuardado;

  const EditarPlantaScreen({
    super.key,
    required this.planta,
    this.onGuardado
    });

  @override
  State<EditarPlantaScreen> createState() => _EditarPlantaScreenState();
}

class _EditarPlantaScreenState extends State<EditarPlantaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PlantasService();

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

  void main(){
    
  }
  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      final updatedPlanta = Planta(
        id: widget.planta.id,
        nameplants: nameCtrl.text,
        typeplants: typeCtrl.text,
        numberbag: bagCtrl.text,
        cantidad: int.tryParse(cantidadCtrl.text) ?? 0,
        price: double.tryParse(priceCtrl.text) ?? 0,
        estado: estadoCtrl.text,
      );

      final ok = await _service.editarPlanta(updatedPlanta);

      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Planta actualizada correctamente')),
        );
      widget.onGuardado?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar la planta o Ya existe')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Planta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre de la planta'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Tipo de planta')),
              TextFormField(controller: bagCtrl, decoration: const InputDecoration(labelText: 'Número de bolsa')),
              TextFormField(
                controller: cantidadCtrl,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(controller: estadoCtrl, decoration: const InputDecoration(labelText: 'Estado')),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _guardarCambios,
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
