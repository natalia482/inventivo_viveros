import 'package:flutter/material.dart';

// Definición de Colores
class DashboardColors {
  static const Color sidebarBackground = Color(0xFF1A5327); 
  static const Color itemColor = Colors.white; 
  static const Color accentColor = Color(0xFF4CAF50); 
}

// Estilos de Texto Base
TextStyle _getSidebarItemStyle(bool isMobile) {
  return TextStyle(
    color: DashboardColors.itemColor,
    fontSize: isMobile ? 16 : 20, 
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto', 
  );
}

// ******************************************************
// WIDGET 1: Ítem de Submenú Desplegable (ExpansionTile)
// ******************************************************

class SidebarExpansionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> subItems;
  final ValueChanged<String> onSubItemTap;
  final bool isMobile;
  final bool isExpanded;

  const SidebarExpansionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subItems,
    required this.onSubItemTap,
    this.isMobile = false,
    this.isExpanded = true
  });

  @override
  Widget build(BuildContext context) {
    // Usamos Theme para asegurar que los colores de ExpansionTile sean correctos
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: const Color.fromARGB(255, 0, 0, 0), // Color de la flecha
        colorScheme: ColorScheme.light(primary: const Color.fromARGB(255, 255, 255, 255)), // Color al expandir
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 20, vertical: isMobile ? 4 : 0),
        leading: Icon(
          icon,
          color: DashboardColors.itemColor,
          size: isMobile ? 24 : 28,
        ),
        title: Text(
          title,
          style: _getSidebarItemStyle(isMobile),
        ),
        children: subItems.map((item) {
          return ListTile(
            contentPadding: EdgeInsets.only(left: isMobile ? 40 : 50, right: 15),
            title: Text(
              item,
              style: _getSidebarItemStyle(isMobile).copyWith(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
            onTap: () => onSubItemTap(item), // Manejo de la navegación del subítem
          );
        }).toList(),
      ),
    );
  }
}

// ******************************************************
// WIDGET 2: Ítem de Navegación Simple (para Salir/Configuración)
// ******************************************************

class SidebarSimpleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isMobile;

  const SidebarSimpleItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: DashboardColors.itemColor, size: isMobile ? 24 : 28),
      title: Text(title, style: _getSidebarItemStyle(isMobile)),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 20, vertical: isMobile ? 4 : 8),
    );
  }
}

// ******************************************************
// WIDGET 3: El Header del Sidebar 
// ******************************************************

class DashboardSidebarHeader extends StatelessWidget {
  final bool isMobile; 

  const DashboardSidebarHeader({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: isMobile ? 20 : 40, left: 20, bottom: isMobile ? 10 : 20),
          child: 
            Text(
              'INVENTIVO', 
              style: TextStyle(
                color: DashboardColors.itemColor,
                fontSize: isMobile ? 24 : 32, 
                fontWeight: FontWeight.w900,
                fontFamily: 'Roboto',
              ),
            ),

        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: isMobile ? 10 : 20),
          child: const Row(
            children: [
              Icon(Icons.person_pin, color: DashboardColors.itemColor, size: 40),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Natalia', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Administrador', style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white54, indent: 20, endIndent: 20),
        SizedBox(height: isMobile ? 5 : 10),
      ],
    );
  }
}


// ******************************************************
// WIDGET 4: El Sidebar Completo (Con Items de Expansión)
// ******************************************************

class DashboardSidebar extends StatelessWidget {
  final ValueChanged<String> onNavigation;
  final bool isMobile; 
  // Añadimos toggleSidebar para el control de mostrar/esconder
  final VoidCallback? toggleSidebar; 

  const DashboardSidebar({
    super.key,
    required this.onNavigation,
    this.isMobile = false, 
    this.toggleSidebar, // Es opcional ya que no se usa en móvil
  });

  @override
  Widget build(BuildContext context) {
    final double? sidebarWidth = isMobile ? null : 280.0; 

    return Container(
      width: sidebarWidth, 
      color: DashboardColors.sidebarBackground,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LLAMADA AL HEADER
            DashboardSidebarHeader(isMobile: isMobile), 
            
            // Items con Submenú (ExpansionTile)
            SidebarExpansionItem(
              icon: Icons.grass,
              title: 'Plantas',
              subItems: const ['Agregar Plantas', 'Editar Plantas'],
              onSubItemTap: onNavigation, // La función onNavigation maneja el subítem
              isMobile: isMobile,
            ),
            SidebarExpansionItem(
              icon: Icons.inventory_2,
              title: 'Insumos',
              subItems: const ['Agregar Insumos', 'Registro de abono'],
              onSubItemTap: onNavigation,
              isMobile: isMobile,
            ),
            SidebarExpansionItem(
              icon: Icons.receipt_long,
              title: 'Facturación',
              subItems: const ['Crear Factura'],
              onSubItemTap: onNavigation,
              isMobile: isMobile,
            ),
            SidebarExpansionItem(
              icon: Icons.people,
              title: 'Personal',
              subItems: const ['Agregar empleado'],
              onSubItemTap: onNavigation,
              isMobile: isMobile,
            ),
            
            //const Spacer(), 

            // Opciones Simples (ListTile)
            SidebarSimpleItem(
              icon: Icons.logout,
              title: 'Salir',
              onTap: () => onNavigation('Salir'),
              isMobile: isMobile,
            ),
            SidebarSimpleItem(
              icon: Icons.settings,
              title: 'Configuración',
              onTap: () => onNavigation('Configuración'),
              isMobile: isMobile,
            ),
            SizedBox(height: isMobile ? 10 : 20), 
          ],
        ),
      ),
    );
  }
}