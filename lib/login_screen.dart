import 'package:flutter/material.dart';
import 'package:inventivo_viveros/dashboard.dart';
import 'package:inventivo_viveros/register_screen.dart';
import 'package:inventivo_viveros/widgets/background_section_home.dart';
import 'package:inventivo_viveros/widgets/header_section_home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: InventivoBackground(
        child: Stack(
          children: [
            // 🔹 Header superior reutilizable
            Positioned(
              top: isMobile ? 30 : 40,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 60,
                ),
                child: InventivoHeader(isMobile: isMobile),
              ),
            ),

            // 🔹 Contenido principal centrado
            Center(
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double width = constraints.maxWidth;
                    double cardWidth = width < 600 ? width * 0.9 : 450;

                    return Container(
                      width: cardWidth,
                      margin: EdgeInsets.only(
                          top: isMobile ? 180 : 220), // deja espacio al header
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.88),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D6832),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Campo de Correo
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: Color(0xFF0D6832)),
                              hintText: "Correo Electrónico",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Campo de Contraseña
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: Color(0xFF0D6832)),
                              hintText: "Contraseña",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Botón principal
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (context)=> const MainDashboardScreen()),
                                  );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 31, 99, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                "INGRESAR",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Enlaces
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "¿No tienes cuenta?",
                                style: TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Regístrate aquí",
                                  style: TextStyle(
                                    color: Color(0xFF0D6832),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(
                              color: Color(0xFF0D6832),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
