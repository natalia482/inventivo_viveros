import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String backendFolder = "backend_inventivo/api/plantas";

  static String getBaseUrl() {
    if (kIsWeb) {
      return "http://192.168.81.34/$backendFolder";
    }
    if (Platform.isAndroid) {
      return "http://10.0.2.2/$backendFolder";
    }
    return "http://127.0.0.1/$backendFolder";
  }

  // Endpoints
  static String get listPlantasUrl => "${getBaseUrl()}/listar.php";
  static String get addPlantaUrl => "${getBaseUrl()}/agregar.php";
  static String get updatePlantaUrl => "${getBaseUrl()}/editar.php";
}
