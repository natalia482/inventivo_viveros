import 'package:flutter/material.dart';

class SidebarDashboard extends StatefulWidget {
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
  State<SidebarDashboard> createState() => _SidebarDashboardState();
}

class _SidebarDashboardState extends State<SidebarDashboard> {
  bool _submenuPlantasAbierto = false; // controla si el submenú está desplegado

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
                        'assets/images/robot.png', // asegúrate de tenerla en assets/images/
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      widget.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.role,
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

            // 🌿 Menú principal
            _buildMenuItem(
              icon: Icons.eco,
              text: "Dashboard",
              index: 0,
              onTap: widget.onMenuSelected,
              context: context,
            ),

            // 🪴 Menú con subopciones (Plantas)
            ListTile(
              leading: const Icon(Icons.local_florist, color: Colors.white),
              title: const Text(
                "Plantas",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Icon(
                _submenuPlantasAbierto
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.white70,
              ),
              onTap: () {
                setState(() {
                  _submenuPlantasAbierto = !_submenuPlantasAbierto;
                });
              },
            ),

            // 🌱 Submenú desplegable
            if (_submenuPlantasAbierto) ...[
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text(
                        "Lista plantas",
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onMenuSelected(1); // índice para lista
                      },
                    ),
                    ListTile(
                      title: const Text(
                        "Registrar plantas",
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onMenuSelected(2); // índice para registrar
                      },
                    ),
                  ],
                ),
              ),
            ],

            _buildMenuItem(
              icon: Icons.inventory_2,
              text: "Insumos",
              index: 3,
              onTap: widget.onMenuSelected,
              context: context,
            ),
            _buildMenuItem(
              icon: Icons.receipt_long,
              text: "Facturación",
              index: 4,
              onTap: widget.onMenuSelected,
              context: context,
            ),
            _buildMenuItem(
              icon: Icons.group,
              text: "Personal",
              index: 5,
              onTap: widget.onMenuSelected,
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
              onTap: widget.onLogout,
            ),

            // ⚙️ Configuración
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                "Configuración",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {}, // puedes asignar un índice si deseas
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // 🔹 Función para crear botones principales del menú
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
        Navigator.pop(context); // cierra el drawer
        onTap(index);
      },
    );
  }
}
