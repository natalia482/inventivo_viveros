import 'package:flutter/material.dart';
import 'package:inventivo_viveros/screens/dashboard.dart';
import 'package:inventivo_viveros/screens/register_screen.dart';
import 'package:inventivo_viveros/screens/home_page.dart';
import 'package:inventivo_viveros/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = prefs.getBool('isLogged') ?? false;

  runApp(MyApp(isLogged: isLogged));
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogged ? const DashboardScreen() : const HomePage(),
    );
  }
}
