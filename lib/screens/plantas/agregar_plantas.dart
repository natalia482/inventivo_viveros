import 'package:flutter/material.dart';
import 'package:inventivo_viveros/models/planta_model.dart';
import 'package:inventivo_viveros/services/planta_service.dart';

class AgregarPlantaScreen extends StatefulWidget {
  const AgregarPlantaScreen({super.key});

  @override
  State<AgregarPlantaScreen> createState() => _AgregarPlantaScreenState();
}

class _AgregarPlantaScreenState extends State<AgregarPlantaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController numberBagController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    numberBagController.dispose();
    cantidadController.dispose();
    priceController.dispose();
    super.dispose();
  }

  

  Future<void> _agregarPlanta() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final planta = Planta(
        id: 0,
        nameplants: nameController.text.trim(),
        typeplants: typeController.text.trim(),
        numberbag: numberBagController.text.trim(),
        cantidad: int.tryParse(cantidadController.text) ?? 0,
        price: double.tryParse(priceController.text) ?? 0.0,
        estado: "Disponible",
        fechaRegistro: DateTime.now(),
      );

      final success = await PlantasService().agregarPlanta(planta);

      setState(() => isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Planta agregada correctamente')),
        );
        _formKey.currentState!.reset();
        nameController.clear();
        typeController.clear();
        numberBagController.clear();
        cantidadController.clear();
        priceController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La planta ya existe')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🚨 Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Agregar Nueva Planta 🌿",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Nombre de la planta"),
                      validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                    ),
                    TextFormField(
                      controller: typeController,
                      decoration: const InputDecoration(labelText: "Tipo de planta"),
                    ),
                    TextFormField(
                      controller: numberBagController,
                      decoration: const InputDecoration(labelText: "Número de bolsa"),
                      validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                    ),
                    TextFormField(
                      controller: cantidadController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Cantidad"),
                      validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                    ),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Precio"),
                      validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _agregarPlanta,
                      icon: const Icon(Icons.add),
                      label: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Agregar Planta"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
