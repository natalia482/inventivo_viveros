import 'package:flutter/material.dart';

class configurationPage extends StatefulWidget {
  const configurationPage({super.key});

  @override
  State<configurationPage> createState() => _configurationPageState();
}

class _configurationPageState extends State<configurationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.settings, size: 60, color: Color(0xFF2E6B3F)),
              SizedBox(height: 20),
              Text(
                "Configuración del Sistema",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E6B3F),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Aquí podrás ajustar parámetros como idioma, tema o usuario.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
