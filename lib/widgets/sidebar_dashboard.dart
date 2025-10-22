import 'package:flutter/material.dart';

class SidebarDashboard extends StatelessWidget {
  final String userName;
  final String role;
  final Function(int) onMenuSelected;
  final VoidCallback onLogout;

  const SidebarDashboard({
    super.key,
    required this.userName,
    required this.role,
    required this.onMenuSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.green[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[700]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.eco, color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    "INVENTIVO",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$userName ($role)",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // 🔹 Opciones de navegación
            _buildMenuItem(
              icon: Icons.home,
              text: "Inicio",
              index: 0,
              onTap: onMenuSelected,
              context: context,
            ),
            _buildMenuItem(
              icon: Icons.list_alt,
              text: "Listar Plantas",
              index: 1,
              onTap: onMenuSelected,
              context: context,
            ),
            _buildMenuItem(
              icon: Icons.add_circle_outline,
              text: "Agregar Planta",
              index: 2,
              onTap: onMenuSelected,
              context: context,
            ),

            const Spacer(),

            // 🔹 Logout al final
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Cerrar Sesión"),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required int index,
    required Function(int) onTap,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[800]),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context); // Cierra el drawer
        onTap(index);
      },
    );
  }
}
