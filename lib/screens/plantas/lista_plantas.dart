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

  Widget _botonCategoria(String texto, {bool activo = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: activo ? const Color(0xFF204E2F) : Colors.white,
          foregroundColor: activo ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black12),
          ),
        ),
        onPressed: () {},
        child: Text(texto, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F0), // fondo gris claro
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔠 Título y botón superior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lista plantas',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  width: 440,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar productos',
                      hintStyle: const TextStyle(color: Colors.black54),
                      prefixIcon: const Icon(Icons.search, color: Colors.black54),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: _buscarPlantas,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF204E2F),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Agregar productos',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🔘 Botones de categoría
            Row(
              children: [
                _botonCategoria('Todas las categorías', activo: true),
                _botonCategoria('Ornamentales'),
                _botonCategoria('Cactus'),
                _botonCategoria('Suculentos'),
                _botonCategoria('Otras'),
              ],
            ),
            const SizedBox(height: 16),

            // 📋 Tabla de productos
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _cargando
                    ? const Center(child: CircularProgressIndicator())
                    : _plantasFiltradas.isEmpty
                        ? const Center(
                            child: Text('No se encontraron plantas.',
                                style: TextStyle(fontSize: 16, color: Colors.black54)),
                          )
                        : SingleChildScrollView(
                            child: DataTable(
                              headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.black),
                              columns: const [
                                DataColumn(label: Text('Plantas')),
                                DataColumn(label: Text('Categoría')),
                                DataColumn(label: Text('Precio')),
                                DataColumn(label: Text('Stock')),
                                DataColumn(label: Text('Acciones')),
                              ],
                              rows: _plantasFiltradas.map((planta) {
                                return DataRow(cells: [
                                  DataCell(Text(planta.nameplants)),
                                  DataCell(Text(planta.typeplants)),
                                  DataCell(Text('\$${planta.price}')),
                                  DataCell(Text(planta.cantidad.toString())),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.black87),
                                      onPressed: () => widget.onEditar(planta),
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
