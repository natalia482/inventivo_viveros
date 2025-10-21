import 'package:flutter/material.dart';
import 'package:inventivo_viveros/models/planta_model.dart';
import 'package:inventivo_viveros/services/planta_service.dart';
import 'package:inventivo_viveros/screens/plantas/editar_plantas.dart';

class PlantasScreen extends StatefulWidget {
  const PlantasScreen({super.key});

  @override
  State<PlantasScreen> createState() => _PlantasScreenState();
}

class _PlantasScreenState extends State<PlantasScreen> {
  final PlantasService _service = PlantasService();
  late Future<List<Planta>> _plantasFuture;

  @override
  void initState() {
    super.initState();
    _plantasFuture = _service.listarPlantas();
  }

  Future<void> _refresh() async {
    setState(() {
      _plantasFuture = _service.listarPlantas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Planta>>(
        future: _plantasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final plantas = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: plantas.length,
              itemBuilder: (context, index) {
                final planta = plantas[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(planta.nameplants),
                    subtitle: Text(
                        "Tipo: ${planta.typeplants}\nCantidad: ${planta.cantidad}\nPrecio: \$${planta.price}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () async {
                        // 👇 Navegamos al editor pasando la planta seleccionada
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarPlantaScreen(planta: planta),
                          ),
                        );

                        // Si se actualizó, refrescamos la lista
                        if (updated == true) _refresh();
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
