import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:inventivo_viveros/services/api_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final cityController = TextEditingController();
  final documentController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  String tipoDocumento = "CÉDULA DE CIUDADANÍA";
  bool isLoading = false;

  Future<void> registerUser() async {
    final pass = passwordController.text.trim();
    final confirm = confirmpasswordController.text.trim();

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => isLoading = true);

    final response = await http.post(Uri.parse(registerUrl), body: {
      "name": nameController.text.trim(),
      "lastname": lastnameController.text.trim(),
      "city": cityController.text.trim(),
      "typedocument": tipoDocumento,
      "document": documentController.text.trim(),
      "email": emailController.text.trim(),
      "password": pass,
      "rol": "Administrador"
    });

    setState(() => isLoading = false);

    final data = json.decode(response.body);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(data['message'])));
    if (data['success']) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  InputDecoration customDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.green.shade700),
      hintText: hint, // 👈 Aquí el cambio
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
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

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Registrar Administrador",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 35),

                  // Dos columnas
                  Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 18,
                    spacing: 18,
                    children: [
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: nameController,
                          decoration: customDecoration("Nombres", Icons.person),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: lastnameController,
                          decoration:
                              customDecoration("Apellidos", Icons.person_outline),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: DropdownButtonFormField<String>(
                          value: tipoDocumento,
                          decoration: customDecoration(
                              "Tipo de documento", Icons.arrow_drop_down),
                          items: const [
                            DropdownMenuItem(
                                value: "CÉDULA DE CIUDADANÍA",
                                child: Text("CÉDULA DE CIUDADANÍA")),
                            DropdownMenuItem(
                                value: "NIT", child: Text("NIT")),
                          ],
                          onChanged: (value) =>
                              setState(() => tipoDocumento = value!),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: documentController,
                          decoration: customDecoration(
                              "Número de documento", Icons.badge_outlined),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: cityController,
                          decoration:
                              customDecoration("Ciudad", Icons.location_city),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: emailController,
                          decoration: customDecoration(
                              "Correo electrónico", Icons.email_outlined),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration:
                              customDecoration("Contraseña", Icons.lock_outline),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: confirmpasswordController,
                          obscureText: true,
                          decoration: customDecoration(
                              "Confirmar contraseña", Icons.lock_person),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // Botón de registrar
                  ElevatedButton(
                    onPressed: isLoading ? null : registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF184A2C),
                      minimumSize: const Size(180, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "REGISTRAR",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                  ),

                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/'),
                    child: const Text(
                      "¿Ya tienes cuenta? Inicia sesión",
                      style: TextStyle(color: Colors.white),
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
