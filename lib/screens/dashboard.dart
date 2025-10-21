import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventivo_viveros/screens/login_screen.dart';
import 'package:inventivo_viveros/widgets/header_dashboard.dart';
import 'package:inventivo_viveros/screens/plantas/lista_plantas.dart';
import 'package:inventivo_viveros/screens/plantas/agregar_plantas.dart';
import 'package:inventivo_viveros/screens/plantas/editar_plantas.dart';
import 'package:inventivo_viveros/models/planta_model.dart';

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
      role = prefs.getString('rol') ?? 'trabajador';
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

  /// Controla qué pantalla se muestra en el cuerpo del dashboard
  void _onMenuSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _plantaSeleccionada = null; // resetea la edición
    });
  }

  /// Abre el editor de una planta dentro del dashboard
  void _abrirEditarPlanta(Planta planta) {
    setState(() {
      _plantaSeleccionada = planta;
      _selectedIndex = 3; // índice especial para edición
    });
  }

  @override
  Widget build(BuildContext context) {
    if (email == null || role == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Lista de páginas normales
    final List<Widget> pages = [
      const Center(child: Text("Bienvenido al panel de control", style: TextStyle(fontSize: 18))),
      PlantasScreen(onEditar: _abrirEditarPlanta), // <-- Aquí enviamos la función para editar
      AgregarPlantaScreen(
        onGuardado: () {
          setState(() {
            _selectedIndex=1;
          });
        },
      ),
      if (_plantaSeleccionada != null)
        EditarPlantaScreen(
          planta: _plantaSeleccionada!,
          onGuardado: () {
            setState(() {
              _selectedIndex = 1; // 👈 vuelve a la lista
              _plantaSeleccionada = null;
            });
          },
        )
      else
        const Center(child: Text('Seleccione una planta para editar')),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderDashboard(
          userName: name ?? 'Usuario',
          role: role ?? 'trabajador',
          onMenuSelected: _onMenuSelected,
          onLogout: logout,
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_selectedIndex],
      ),
    );
  }
}
