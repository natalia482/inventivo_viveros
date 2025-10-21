import 'package:flutter/material.dart';
import 'package:inventivo_viveros/models/planta_model.dart';
import 'package:inventivo_viveros/services/planta_service.dart';

class PlantasScreen extends StatefulWidget {
  final Function(Planta)? onEditar; // <--- callback opcional

  const PlantasScreen({super.key, this.onEditar});

  @override
  State<PlantasScreen> createState() => _PlantasScreenState();
}

class _PlantasScreenState extends State<PlantasScreen> {
  final _service = PlantasService();
  List<Planta> _plantas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarPlantas();
  }

  Future<void> _cargarPlantas() async {
    try {
      final lista = await _service.listarPlantas();
      setState(() {
        _plantas = lista;
        _loading = false;
      });
    } catch (e) {
      print("Error cargando plantas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_plantas.isEmpty) {
      return const Center(child: Text('No hay plantas registradas'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: _plantas.length,
        itemBuilder: (context, index) {
          final p = _plantas[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(p.nameplants),
              subtitle: Text('Tipo: ${p.typeplants} | Precio: ${p.price} |  Cantidad: ${p.cantidad}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // si viene del dashboard, llama al callback
                      if (widget.onEditar != null) {
                        widget.onEditar!(p);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
