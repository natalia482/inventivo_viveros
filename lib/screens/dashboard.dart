import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:inventivo_viveros/widgets/header_dashboard.dart';
import 'plantas/lista_plantas.dart';
import 'plantas/agregar_plantas.dart';
import 'plantas/editar_plantas.dart';

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

  final List<Widget> _pages = [
    const Center(child: Text("Bienvenido al panel de control", style: TextStyle(fontSize: 18))),
    const PlantasScreen(),
    const AgregarPlantaScreen(),
  ];

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

  // 🔹 Función que se ejecutará cuando el usuario cambie de vista desde el header
  void _onMenuSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (email == null || role == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderDashboard(
          userName: name ?? 'Usuario',
          role: role ?? 'trabajador',
          onMenuSelected: _onMenuSelected, // 👈 Pasamos el callback
          onLogout: logout,
        ),
      ),
      body: _pages[_selectedIndex], // 👈 cambia el contenido del cuerpo
    );
  }
}
