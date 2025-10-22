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
      width: 220,
      child: Container(
        color: const Color(0xFF2E6B3F), // Verde oscuro tipo el de la imagen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧠 Encabezado con logo e info del usuario
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del robot
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        'assets/images/robot.png', // Asegúrate de que esté en assets/images/
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      role,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🌿 Opciones de navegación principales
            _buildMenuItem(
              icon: Icons.eco,
              text: "Dashboard",
              index: 0,
              onTap: onMenuSelected,
              context: context,
            ),
            _buildMenuItem(
              icon: Icons.local_florist,
              text: "Plantas",
              index: 1,
              onTap: onMenuSelected,
              context: context,
            ),
            _buildMenuItem(
              icon: Icons.inventory_2,
              text: "Insumos",
              index: 2,
              onTap: onMenuSelected,
              context: context,
            ),
            _buildMenuItem(
              icon: Icons.receipt_long,
              text: "Facturación",
              index: 3,
              onTap: onMenuSelected,
              context: context,
            ),
            _buildMenuItem(
              icon: Icons.group,
              text: "Personal",
              index: 4,
              onTap: onMenuSelected,
              context: context,
            ),

            const Spacer(),

            // 🔹 Opción de salir
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                "Salir",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: onLogout,
            ),

            // ⚙️ Opción de configuración (no funcional aún, puedes asignarle índice si deseas)
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                "Configuración",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {}, // puedes poner otro onMenuSelected si deseas
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget auxiliar para crear cada botón del menú
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required int index,
    required Function(int) onTap,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Cierra el drawer
        onTap(index);
      },
    );
  }
}
