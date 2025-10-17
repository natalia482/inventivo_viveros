import 'package:flutter/material.dart';
import 'package:inventivo_viveros/login_screen.dart';
import 'package:inventivo_viveros/widgets/background_section_home.dart';
import 'package:inventivo_viveros/widgets/header_section_home.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      body: InventivoBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 50),
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: InventivoHeader(isMobile: isMobile),
                ),

                // TÍTULO
                const Text(
                  "Registrar administrador",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 40),

                // FORMULARIO
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double fieldWidth =
                        isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 20;

                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildInputField(Icons.person, "Nombres", width: fieldWidth),
                        _buildInputField(Icons.person, "Apellidos", width: fieldWidth),
                        _buildInputField(Icons.location_city, "Ciudad", width: fieldWidth),
                        _buildInputField(Icons.email, "Correo electrónico",
                            width: fieldWidth),
                        _buildInputField(Icons.lock, "Contraseña", width: fieldWidth, obscure: true),
                        _buildInputField(Icons.lock_outline, "Confirmar contraseña",
                            width: fieldWidth, obscure: true),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 40),

                // BOTÓN REGISTRAR
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute<void>(builder: (context) => const LoginPage()),
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A5327),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "REGISTRAR",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- CAMPO PERSONALIZADO ---
  Widget _buildInputField(IconData icon, String label,
      {required double width, bool obscure = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color.fromARGB(135, 0, 0, 0), size: 20),
          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
