import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventivo_viveros/screens/dashboard.dart';
import 'register_screen.dart';

const String loginUrl = "http://127.0.0.1/backend_inventivo/api/login.php";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, completa todos los campos")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogged', true);
        await prefs.setString('email', email);
        await prefs.setString('rol', data['rol'] ?? 'trabajador');
        await prefs.setString('name', data['name'] ?? 'Usuario');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bienvenido ${data['name']}")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Error al iniciar sesión")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Para hacerlo adaptable a distintos tamaños de pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth < 400 ? screenWidth * 0.85 : 350.0;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo con filtro verdoso
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/fondo.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.green.withOpacity(0.45),
                  BlendMode.overlay,
                ),
              ),
            ),
          ),

          // Filtro oscuro leve
          Container(color: Colors.black.withOpacity(0.25)),

          // Contenido principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Campo de correo
                  SizedBox(
                    width: formWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.person_outline, color: Colors.grey),
                          hintText: "Correo Electrónico",
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo de contraseña
                  SizedBox(
                    width: formWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.grey),
                          hintText: "Contraseña",
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón principal
                  SizedBox(
                    width: formWidth,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 6,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "INGRESAR",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.white, // <-- Blanco puro
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Enlace de registro
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Regístrate aquí",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Enlace de olvido de contraseña
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
