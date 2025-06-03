class Moneda {
  final int? id;
  final String nombre;
  final double tipoCambio;

  Moneda({this.id, required this.nombre, required this.tipoCambio});

  factory Moneda.fromMap(Map<String, dynamic> map) => Moneda(
    id: map['id'],
    nombre: map['nombre'],
    tipoCambio: map['tipo_cambio'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'tipo_cambio': tipoCambio,
  };
}
