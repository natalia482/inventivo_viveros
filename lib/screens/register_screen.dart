import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
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
    //validaciones de campos vaciones
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
                    const Text("Registro de Administrador",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    const SizedBox(height: 20),
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nombres")),
                    TextField(controller: lastnameController, decoration: const InputDecoration(labelText: "Apellidos")),
                    TextField(controller: cityController, decoration: const InputDecoration(labelText: "Ciudad")),
                    DropdownButtonFormField<String>(
                      value: tipoDocumento,
                      decoration: const InputDecoration(labelText: "Tipo de documento"),
                      items: const [
                        DropdownMenuItem(value: "CÉDULA DE CIUDADANÍA", child: Text("CÉDULA DE CIUDADANÍA")),
                        DropdownMenuItem(value: "NIT", child: Text("NIT")),
                      ],
                      onChanged: (value) => setState(() => tipoDocumento = value!),
                    ),
                    TextField(controller: documentController, decoration: const InputDecoration(labelText: "Número de documento")),
                    TextField(controller: emailController, decoration: const InputDecoration(labelText: "Correo electrónico")),
                    TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Contraseña")),
                    TextField(controller: confirmpasswordController, obscureText: true, decoration: const InputDecoration(labelText: "Confirmar contraseña")),
                    
                    const SizedBox(height: 20),
                    
                    ElevatedButton(
                      onPressed: isLoading ? null : registerUser,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 45)),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("REGISTRAR ADMINISTRADOR"),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/'),
                      child: const Text("¿Ya tienes cuenta? Inicia sesión"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
