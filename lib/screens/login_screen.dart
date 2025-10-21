import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventivo_viveros/screens/dashboard.dart';
import 'register_screen.dart';

// ✅ Cambia por tu IP local o usa 10.0.2.2 si estás en emulador Android
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
      // ✅ Se envía en formato JSON
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("📩 Respuesta del servidor: ${response.body}");

      final data = json.decode(response.body);

      if (data['success'] == true) {
        // ✅ Guardar datos en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogged', true);
        await prefs.setString('email', email);
        await prefs.setString('rol', data['rol'] ?? 'trabajador');
        await prefs.setString('name', data['name'] ?? 'Usuario');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bienvenido ${data['name']}")),
        );

        // ✅ Ir al Dashboard
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
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fondo.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(color: Colors.black.withOpacity(0.5)),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text("INICIAR SESIÓN",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    const SizedBox(height: 20),
                    TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            labelText: "Correo electrónico")),
                    const SizedBox(height: 10),
                    TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: "Contraseña")),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 45)),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("INGRESAR"),
                    ),
                    const SizedBox(height: 10),
                TextButton(
                      onPressed: () => Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),),
                      child: const Text("¿No tienes cuenta? Regístrate aquí"),
                    ),                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
