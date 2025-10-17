import 'package:flutter/material.dart';
import 'package:inventivo_viveros/widgets/header_dashboard.dart'; 

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  String _currentRoute = 'Dashboard';
  bool _isSidebarExpanded = true; // Estado para controlar si el sidebar está abierto o cerrado

  // Anchos definidos para la animación
  static const double _expandedWidth = 280.0;
  static const double _collapsedWidth = 70.0; // Ancho cuando está escondido (solo iconos)
  
  void _handleNavigation(String route) {
    setState(() {
      _currentRoute = route;
    });
    // Si estamos en móvil y el sidebar es un Drawer, lo cerramos al navegar
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700; 

    // Define el ancho del sidebar para la animación (solo en desktop)
    final double currentWidth = _isSidebarExpanded ? _expandedWidth : _collapsedWidth;

    return Scaffold(
      appBar: isMobile 
          ? AppBar(
              backgroundColor: DashboardColors.sidebarBackground,
              title: const Text('Inventivo Dashboard', style: TextStyle(color: Colors.white)),
            )
          : null, 
      drawer: isMobile 
          ? DashboardSidebar( 
              onNavigation: _handleNavigation,
              isMobile: true,
            )
          : null,
      body: Row(
        children: [
          // 1. Sidebar (Controlado por AnimatedContainer y isMobile)
          if (!isMobile)
            // Solo en desktop, usamos AnimatedContainer para la transición de esconder/mostrar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: currentWidth,
              child: DashboardSidebar(
                onNavigation: _handleNavigation,
                isMobile: false
                // Agregamos el botón para alternar el estado (se implementará un botón flotante)
              ),
            ),
          
          // 2. Contenido Principal del Dashboard
          Expanded(
            child: Stack( // Usamos Stack para el botón flotante de control
              children: [
                Container(
                  color: Colors.white, 
                  padding:  EdgeInsets.all(isMobile ? 15 : 30), 
                  child: Center(
                    child: Text('Contenido de la sección: $_currentRoute', style: const TextStyle(fontSize: 24)),
                  )
                ),
                
                // Botón para Esconder/Mostrar Sidebar (Solo visible en Desktop)
                if (!isMobile)
                  Positioned(
                    top: 15,
                    left: 15,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: DashboardColors.sidebarBackground,
                      onPressed: _toggleSidebar,
                      child: Icon(
                        _isSidebarExpanded ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
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