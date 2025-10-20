import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastnameCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController tdocumentCtrl = TextEditingController();
  TextEditingController documentCtrl = TextEditingController();  
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  Future<void> registrarUsuario() async {
    var url = Uri.parse("http://127.0.0.1/backend_inventivo/api/register.php"); // Para emulador Android
    var response = await http.post(url, body: {
      "name": nameCtrl.text,
      "lastname": lastnameCtrl.text,
      "city": cityCtrl.text,
      "typedocument": tdocumentCtrl.text,
      "document": documentCtrl.text,
      "email": emailCtrl.text,
      "password": passwordCtrl.text,
    });

    

    var data = json.decode(response.body);
    print(data); //
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));

    if (data["success"]) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Nombre")),
            TextField(controller: lastnameCtrl, decoration: InputDecoration(labelText: "Apellido")),
            TextField(controller: cityCtrl, decoration: InputDecoration(labelText: "Ciudad")),
            TextField(controller: tdocumentCtrl, decoration: InputDecoration(labelText: "Tipo de documento")),
            TextField(controller: documentCtrl, decoration: InputDecoration(labelText: "documento")),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Correo")),
            TextField(controller: passwordCtrl, decoration: InputDecoration(labelText: "Contraseña"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: registrarUsuario, child: Text("Registrar")),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: Text("¿Ya tienes cuenta? Inicia sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
