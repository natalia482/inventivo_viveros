import 'package:flutter/material.dart';

class HeaderDashboard extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String role;
  final Function(int) onMenuSelected;
  final VoidCallback onLogout;

  const HeaderDashboard({
    super.key,
    required this.userName,
    required this.role,
    required this.onMenuSelected,
    required this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[700],
      title: Row(
        children: [
          const Icon(Icons.eco, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Text("INVENTIVO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const Spacer(),
          // 🔹 Menú de navegación
          TextButton(
            onPressed: () => onMenuSelected(0),
            child: const Text("Inicio", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => onMenuSelected(1),
            child: const Text("Listar Plantas", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => onMenuSelected(2),
            child: const Text("Agregar Planta", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 20),
          // 🔹 Info del usuario y logout
          Row(
            children: [
              Text(
                "$userName ($role)",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
