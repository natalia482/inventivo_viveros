import 'package:flutter/material.dart';
import 'package:inventivo_viveros/models/planta_model.dart';
import 'package:inventivo_viveros/services/planta_service.dart';

class PlantasScreen extends StatefulWidget {
  final Function(Planta) onEditar;

  const PlantasScreen({super.key, required this.onEditar});

  @override
  State<PlantasScreen> createState() => _PlantasScreenState();
}

class _PlantasScreenState extends State<PlantasScreen> {
  final PlantasService _service = PlantasService();
  List<Planta> _plantas = [];
  List<Planta> _plantasFiltradas = [];
  bool _cargando = true;
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    _cargarPlantas();
  }

  Future<void> _cargarPlantas() async {
    setState(() => _cargando = true);
    try {
      final data = await _service.listarPlantas();
      setState(() {
        _plantas = data;
        _plantasFiltradas = data;
      });
    } catch (e) {
      print("❌ Error al listar plantas: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _buscarPlantas(String query) {
    setState(() {
      _busqueda = query.toLowerCase();
      _plantasFiltradas = _plantas.where((planta) {
        return planta.nameplants.toLowerCase().contains(_busqueda) ||
               planta.typeplants.toLowerCase().contains(_busqueda) ||
               planta.estado.toLowerCase().contains(_busqueda);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar planta por nombre o familia...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _buscarPlantas,
            ),
            const SizedBox(height: 16),

            // 🔄 Estado de carga o lista
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : _plantasFiltradas.isEmpty
                      ? const Center(
                          child: Text(
                            'No se encontraron plantas.',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _cargarPlantas,
                          child: ListView.builder(
                            itemCount: _plantasFiltradas.length,
                            itemBuilder: (context, index) {
                              final planta = _plantasFiltradas[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.local_florist, color: Colors.green),
                                  title: Text(planta.nameplants),
                                  subtitle: Text('Precio: ${planta.price}, Bolsa: ${planta.numberbag}, Cantidad: ${planta.cantidad}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => widget.onEditar(planta),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
