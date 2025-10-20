import 'package:flutter/material.dart';
import 'package:inventivo_viveros/screens/home_page.dart';
import 'package:inventivo_viveros/screens/configuration.dart';

// Definición de Colores
class DashboardColors {
  static const Color sidebarBackground = Color(0xFF1A5327); 
  static const Color itemColor = Colors.white; 
  static const Color accentColor = Color(0xFF4CAF50); 
}

// Estilos de Texto Base
TextStyle _getSidebarItemStyle(bool isMobile) {
  return TextStyle(
    color: DashboardColors.itemColor, // color de los iconos del header
    fontSize: isMobile ? 16 : 20, 
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto', 
  );
}

// ******************************************************
// WIDGET 1: Ítem de Submenú Desplegable (CORREGIDO)
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
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: DashboardColors.itemColor,
        colorScheme: ColorScheme.light(primary: const Color.fromARGB(228, 255, 255, 255)), 
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 20, vertical: isMobile ? 4 : 0),
        leading: Icon(
          icon,
          color: DashboardColors.itemColor,
          size: isMobile ? 24 : 28,
        ),
        // Oculta el título si el menú está colapsado (isExpanded es false)
        title: isExpanded 
            ? Text(title, style: _getSidebarItemStyle(isMobile))
            : const SizedBox.shrink(), 
        
        children: isExpanded 
            ? subItems.map((item) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: isMobile ? 40 : 50, right: 15),
                  title: Text(
                    item,
                    style: _getSidebarItemStyle(isMobile).copyWith(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(228, 255, 255, 255),
                    ),
                  ),
                  onTap: () => onSubItemTap(item),
                );
              }).toList() 
            : const [],
      ),
    );
  }
}

// ******************************************************
// WIDGET 2: Ítem de Navegación Simple (CORREGIDO)
// ******************************************************

class SidebarSimpleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isMobile;
  final bool isExpanded; 

  const SidebarSimpleItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isMobile = false,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: DashboardColors.itemColor, size: isMobile ? 24 : 28),
      // Oculta el título si el menú está colapsado
      title: isExpanded ? Text(title, style: _getSidebarItemStyle(isMobile)) : null,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 20, vertical: isMobile ? 4 : 8),
    );
  }
}

// ******************************************************
// WIDGET 3: El Header del Sidebar (CORREGIDO)
// ******************************************************

class DashboardSidebarHeader extends StatelessWidget {
  final bool isMobile; 
  final bool isExpanded; 

  const DashboardSidebarHeader({super.key, this.isMobile = false, this.isExpanded = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Logo/Título (INVENTIVO)
        Padding(
          padding: EdgeInsets.only(top: isMobile ? 20 : 40, left: 20, bottom: isMobile ? 10 : 20),
          child: 
            // LÓGICA DE OCULTAMIENTO DE TÍTULO
            isExpanded 
              ? Text(
                  'INVENTIVo', 
                  style: TextStyle(
                    color: const Color(0xFFF7C948),
                    fontSize: isMobile ? 24 : 32, 
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                )
              : const SizedBox(width: 30, height: 30), // Placeholder
        ),
        
        // 2. Perfil de Usuario (Natalia Administrador)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: isMobile ? 10 : 20),
          // OCULTAR PERFIL AL COLAPSAR
          child: isExpanded
              ? const Row(
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
                )
              : const SizedBox.shrink(),
        ),
        
        // El Divider solo se muestra si está expandido
        if (isExpanded) 
          const Divider(color: Color.fromARGB(232, 255, 254, 254), indent: 20, endIndent: 20),
        SizedBox(height: isMobile ? 5 : 10),
      ],
    );
  }
}


// ******************************************************
// WIDGET 4: El Sidebar Completo 
// ******************************************************
class DashboardSidebar extends StatelessWidget {
  final ValueChanged<String> onNavigation;
  final bool isMobile; 
  final bool isExpanded; 
  final VoidCallback? toggleSidebar; 

  const DashboardSidebar({
    super.key,
    required this.onNavigation,
    this.isMobile = false, 
    this.isExpanded = true, 
    this.toggleSidebar, 
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
            DashboardSidebarHeader(isMobile: isMobile, isExpanded: isExpanded), 
            
            // Items con Submenú (Pasando isExpanded)
            SidebarExpansionItem(
              icon: Icons.grass, title: 'Plantas', subItems: const ['Agregar Plantas', 'Editar Plantas'],
              onSubItemTap: onNavigation, isMobile: isMobile, isExpanded: isExpanded,
            ),
            SidebarExpansionItem(
              icon: Icons.inventory_2, title: 'Insumos', subItems: const ['Agregar Insumos', 'Registro de abono'],
              onSubItemTap: onNavigation, isMobile: isMobile, isExpanded: isExpanded,
            ),
            SidebarExpansionItem(
              icon: Icons.receipt_long, title: 'Facturación', subItems: const ['Crear Factura'],
              onSubItemTap: onNavigation, isMobile: isMobile, isExpanded: isExpanded,
            ),
            SidebarExpansionItem(
              icon: Icons.people, title: 'Personal', subItems: const ['Agregar empleado'],
              onSubItemTap: onNavigation, isMobile: isMobile, isExpanded: isExpanded,
            ),
            SidebarSimpleItem(
              icon: Icons.settings, title: 'Configuración', onTap: () {Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>configurationPage()),);},
              isMobile: isMobile, isExpanded: isExpanded,
            ),
            // Opciones Simples (Pasando isExpanded)
            SidebarSimpleItem(
              icon: Icons.logout, title: 'Salir', onTap: () {Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>HomePage()),);},
              isMobile: isMobile, isExpanded: isExpanded,
            ),
            SizedBox(height: isMobile ? 10 : 20), 
          ],
        ),
      ),
    );
  }
}