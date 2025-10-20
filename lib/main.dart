import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';
import 'screens/register_screen.dart'; // si ya tienes el registro

void main() {
  runApp(const InventivoApp());
}

class InventivoApp extends StatelessWidget {
  const InventivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventivo',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/register': (context) => RegisterPage(), // si existe
      },
    );
  }
}
