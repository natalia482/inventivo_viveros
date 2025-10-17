import 'package:flutter/material.dart';
//import 'package:inventivo_viveros/home_page.dart';
import '../login_screen.dart'; // Ajusta el import según tu estructura

class InventivoHeader extends StatelessWidget {
  final bool isMobile;

  const InventivoHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    // 1. Envolver la estructura del logo en un GestureDetector
    final logo = GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'INVENTIV',
            style: TextStyle(
              color: const Color(0xFFF7C948), // Amarillo
              fontFamily: 'Poppins',
              fontSize: isMobile ? 34 : 48,
              fontWeight: FontWeight.w900,
            ),
          ),
          Container(
            width: isMobile ? 36 : 50,
            height: isMobile ? 36 : 50,
            decoration: const BoxDecoration(
              color: Color(0xFF1A5327),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 28),
          ),
        ],
      ),
    );

    // ... (El resto del código sigue igual)
    final buttons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
      _HeaderButton(text: 'Iniciar Sesión', color: const Color(0xFF0D6832)),
      const SizedBox(width: 15),
      _HeaderButton(text: 'InventiBOT', color: const Color(0xFF1A5327)),
      ],
    );

    return isMobile
        ? Column(
            children: [
              logo,
              const SizedBox(height: 15),
              buttons,
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              logo,
              buttons,
            ],
          );
  }
}

class _HeaderButton extends StatelessWidget {
  final String text;
  final Color color;

  const _HeaderButton({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => const LoginPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 1,
      ),
      child: Text(text),
    );
  }
}