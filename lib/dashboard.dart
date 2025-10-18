import 'package:flutter/material.dart';
import 'package:inventivo_viveros/widgets/header_dashboard.dart'; 
import 'add_plants.dart';


class DashboardColors{
  static const Color sidebarBackground = Color(0xFF1A5327) ;
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  String _currentRoute = 'Dashboard';
  bool _isSidebarExpanded = true; 

  static const double _expandedWidth = 280.0;
  static const double _collapsedWidth = 70.0; 
  
  void _handleNavigation(String route) {
    setState(() {
      _currentRoute = route;
    });
    if (MediaQuery.of(context).size.width < 700) { 
      Navigator.of(context).pop(); 
    }
    print('Navegando a: $route');
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  //CONTENIDO CENTRAL USANDO EL METODO SWITCH
  Widget _buildBodyContent(String route, bool isMobile){
    final double  titleFontSize = isMobile ? 28:36;

    switch (route) {
      case 'Agregar Plantas':
        return const AddPlantScreen();

      case 'Dashboard':
      return Center( child: Text(
        'Dashboard Principal', style: TextStyle(fontSize: titleFontSize, color: Colors.black54),),);

      default:
      return Center(
        child: Text('Contenido de la sección1: $route no implementado'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700; 
    final double currentWidth = _isSidebarExpanded ? _expandedWidth : _collapsedWidth;

    return Scaffold(
      backgroundColor: const Color(0xFF1A5327),
      appBar: isMobile 
          ? AppBar(
              backgroundColor: const Color.from(alpha: 1, red: 0.102, green: 0.325, blue: 0.153),
              title: const Text('Inventiv', style: TextStyle(color: Colors.white)),
            )
          : null, 
      drawer: isMobile 
          ? DashboardSidebar( 
              onNavigation: _handleNavigation,
              isMobile: true,
              isExpanded: true, // El Drawer siempre está 'expandido'
            )
          : null,
      body: Row(
        children: [
          // 1. Sidebar (Controlado por AnimatedContainer y isMobile)
          if (!isMobile)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: currentWidth,
              child: DashboardSidebar(
                onNavigation: _handleNavigation,
                isMobile: false,
                isExpanded: _isSidebarExpanded, 
              ),
            ),
          
          // 2. Contenido Principal del Dashboard
          Expanded(
            child: Stack( 
              children: [
                //Llamada al switch
                _buildBodyContent(_currentRoute, isMobile),

                //Boton de esconder/mostrar el sidebar
                if (!isMobile)
                  Positioned(
                    top: 15,
                    left: 15,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: DashboardColors.sidebarBackground,
                      onPressed: _toggleSidebar,
                      child: Icon(
                        // **👉 CORRECCIÓN DE ICONO:** usar 'arrow_back_ios'
                        _isSidebarExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}