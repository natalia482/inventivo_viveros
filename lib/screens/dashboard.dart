import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventivo_viveros/screens/login_screen.dart';
import 'package:inventivo_viveros/widgets/sidebar_dashboard.dart';
import 'package:inventivo_viveros/screens/plantas/lista_plantas.dart';
import 'package:inventivo_viveros/screens/plantas/agregar_plantas.dart';
import 'package:inventivo_viveros/screens/plantas/editar_plantas.dart';
import 'package:inventivo_viveros/models/planta_model.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? email;
  String? name;
  String? role;
  int _selectedIndex = 0;
  Planta? _plantaSeleccionada;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getBool('isLogged') ?? false;

    if (!isLogged) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    setState(() {
      email = prefs.getString('email') ?? 'Usuario desconocido';
      name = prefs.getString('name') ?? 'Usuario';
      role = prefs.getString('rol') ?? 'Administrador';
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _onMenuSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _plantaSeleccionada = null;
    });
  }

  void _abrirEditarPlanta(Planta planta) {
    setState(() {
      _plantaSeleccionada = planta;
      _selectedIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (email == null || role == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> pages = [
      _buildDashboardPrincipal(),
      PlantasScreen(onEditar: _abrirEditarPlanta),
      AgregarPlantaScreen(
        onGuardado: () => setState(() => _selectedIndex = 1),
      ),
      if (_plantaSeleccionada != null)
        EditarPlantaScreen(
          planta: _plantaSeleccionada!,
          onGuardado: () {
            setState(() {
              _selectedIndex = 1;
              _plantaSeleccionada = null;
            });
          },
        )
      else
        const Center(child: Text('Seleccione una planta para editar')),
    ];

    return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.green[700],
    elevation: 2,
    title: Row(
      children: [
        const Icon(Icons.eco, color: Colors.white),
        const SizedBox(width: 10),
        const Text(
          "INVENTIVO",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  ),
  drawer: SidebarDashboard(
    userName: name ?? 'Usuario',
    role: role ?? 'Administrador',
    onMenuSelected: _onMenuSelected,
    onLogout: logout,
  ),
  body: AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: pages[_selectedIndex],
  ),
);
  }

  // 🌿 Dashboard visual principal
  Widget _buildDashboardPrincipal() {
    return Container(
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard General",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // 📊 Gráficos principales
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildGraficoBarras()),
                const SizedBox(width: 20),
                Expanded(child: _buildGraficoCircular()),
              ],
            ),
            const SizedBox(height: 30),

            const Text(
              "Indicadores clave",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // 💡 Tarjetas inferiores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIndicador(
                  icon: Icons.local_florist,
                  valor: "1,512",
                  titulo: "Total Productos",
                ),
                _buildIndicador(
                  icon: Icons.warning_amber_rounded,
                  valor: "Stock Bajo",
                  titulo: "",
                ),
                _buildIndicador(
                  icon: Icons.attach_money,
                  valor: "\$145,000",
                  titulo: "Ingresos Mes",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📈 Gráfico de barras
  Widget _buildGraficoBarras() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const labels = ['Producto 1', 'Producto 2', 'Producto 3', 'Producto 4'];
                  return Text(labels[value.toInt() % labels.length]);
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 4, color: Colors.green[400], width: 25),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 6, color: Colors.green[600], width: 25),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 8, color: Colors.green[800], width: 25),
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(toY: 10, color: Colors.green[900], width: 25),
            ]),
          ],
        ),
      ),
    );
  }

  // 🥧 Gráfico circular
  Widget _buildGraficoCircular() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 250,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(color: Colors.green[900], value: 40, title: "Cactus"),
            PieChartSectionData(color: Colors.green[600], value: 30, title: "Ornamentales"),
            PieChartSectionData(color: Colors.green[300], value: 20, title: "Suculentas"),
            PieChartSectionData(color: Colors.green[100], value: 10, title: "Otras"),
          ],
          sectionsSpace: 3,
          centerSpaceRadius: 30,
        ),
      ),
    );
  }

  // 🔢 Indicadores inferiores
  Widget _buildIndicador({
    required IconData icon,
    required String valor,
    required String titulo,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green[800], size: 30),
            const SizedBox(height: 8),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (titulo.isNotEmpty)
              Text(
                titulo,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }
}
