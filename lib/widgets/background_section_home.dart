import 'package:flutter/material.dart';

class InventivoBackground extends StatelessWidget {
  final Widget child;

  const InventivoBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Imagen de fondo
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/fondo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Capa de color para oscurecer ligeramente
        Container(color: const Color.fromARGB(150, 9, 77, 15).withOpacity(0.25)),

        // Contenido
        child,
      ],
    );
  }
}