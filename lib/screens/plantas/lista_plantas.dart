import 'package:flutter/material.dart';
import '../../models/planta_model.dart';
import '../../services/planta_service.dart';

class PlantasScreen extends StatefulWidget {
  const PlantasScreen({super.key});

  @override
  State<PlantasScreen> createState() => _PlantasScreenState();
}

class _PlantasScreenState extends State<PlantasScreen> {
  late Future<List<Planta>> _futurePlantas;

  @override
  void initState() {
    super.initState();
    _cargarPlantas();
  }

  void _cargarPlantas() {
    setState(() {
      _futurePlantas = PlantasService().listarPlantas();
    });
  }

  Future<void> _refrescar() async {
    _cargarPlantas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("🌿 Listado de Plantas"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: _refrescar,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder<List<Planta>>(
        future: _futurePlantas,
        builder: (context, snapshot) {
          // 🔹 Muestra mientras carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🔹 Si ocurre un error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar las plantas:\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          // 🔹 Si no hay datos o la lista está vacía
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No hay plantas registradas 🌱"),
            );
          }

          // 🔹 Si hay datos
          final plantas = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refrescar,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: plantas.length,
              itemBuilder: (context, index) {
                final p = plantas[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.local_florist, color: Colors.green),
                    title: Text(
                      p.nameplants,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tipo: ${p.typeplants}"),
                        Text("Número de bolsa: ${p.numberbag}"),
                        Text("Cantidad: ${p.cantidad}"),
                        Text("Precio: \$${p.price}"),
                        Text("Fecha: ${p.fechaRegistro}"),
                      ],
                    ),
                    trailing: Text(
                      p.estado,
                      style: TextStyle(
                        color: p.estado.toLowerCase() == "disponible"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
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
