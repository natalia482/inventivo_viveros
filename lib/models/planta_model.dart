class Planta {
  final int id;
  final String nameplants;
  final String typeplants;
  final String numberbag;
  final int cantidad;
  final double price;
  final String estado;


  Planta({
    required this.id,
    required this.nameplants,
    required this.typeplants,
    required this.numberbag,
    required this.cantidad,
    required this.price,
    required this.estado,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      id: int.parse(json['id'].toString()),
      nameplants: json['nameplants'] ?? '',
      typeplants: json['typeplants'] ?? '',
      numberbag: json['numberbag'] ?? '',
      cantidad: int.parse(json['cantidad'].toString()),
      price: double.parse(json['price'].toString()),
      estado: json['estado'] ?? 'Disponible',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nameplants": nameplants,
      "typeplants": typeplants,
      "numberbag": numberbag,
      "cantidad": cantidad,
      "price": price,
      "estado": estado,
    };
  }
}
