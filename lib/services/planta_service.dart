import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventivo_viveros/config/api_config.dart';
import 'package:inventivo_viveros/models/planta_model.dart';

class PlantasService {
  final String baseUrl = ApiConfig.getBaseUrl();

   Future<List<Planta>> listarPlantas() async {
    final response = await http.get(Uri.parse('$baseUrl/listar.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 🚨 Si el JSON es como [{"id":"1", "nameplants":"Rosa", ...}]
      // debe devolver directamente una lista

      if (data is List) {
        return data.map((e) => Planta.fromJson(e)).toList();
      }

      // 🚨 Pero si el JSON es como {"respuesta": [ {...}, {...} ]}
      // entonces debes acceder así:
      if (data is Map && data.containsKey("respuesta")) {
        return (data["respuesta"] as List)
            .map((e) => Planta.fromJson(e))
            .toList();
      }

      return [];
    } else {
      throw Exception("Error al obtener las plantas: ${response.statusCode}");
    }
  }

  
  

  Future<bool> agregarPlanta(Planta planta) async {
    try {
      final url = Uri.parse('$baseUrl/agregar.php');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(planta.toJson()),
      );

      print("📡 POST → $url");
      print("📤 Enviando: ${planta.toJson()}");
      print("📨 Respuesta: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print("🚨 Error en agregarPlanta(): $e");
      return false;
    }
  }

  Future<bool> editarPlanta(Planta planta) async {
    try {
      final url = Uri.parse('$baseUrl/editar.php');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(planta.toJson()),
      );

      print("📡 PUT → $url");
      print("📤 Enviando: ${planta.toJson()}");
      print("📨 Respuesta: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print("🚨 Error en editarPlanta(): $e");
      return false;
    }
  }
}

