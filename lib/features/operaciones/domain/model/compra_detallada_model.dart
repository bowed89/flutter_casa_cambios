class CompraDetallada {
  final int id;
  final int id_usuario;
  final double total_pagar;
  final double monto_compra;
  final String nombre_moneda;
  final double tipo_cambio;
  final String? imagen;

  CompraDetallada({
    required this.id,
    required this.id_usuario,
    required this.total_pagar,
    required this.monto_compra,
    required this.nombre_moneda,
    required this.tipo_cambio,
    this.imagen,
  });

  factory CompraDetallada.fromMap(Map<String, dynamic> map) {
    return CompraDetallada(
      id: map['id'],
      id_usuario: map['id_usuario'],
      total_pagar: map['total_pagar'],
      monto_compra: map['monto_compra'],
      nombre_moneda: map['nombre_moneda'],
      tipo_cambio: map['tipo_cambio'],
      imagen: map['imagen'],
    );
  }

  @override
  String toString() {
    return 'Compra(id: $id, id_usuario: $id_usuario, total_pagar: $total_pagar, monto_compra: $monto_compra, nombre_moneda: $nombre_moneda, tipo_cambio: $tipo_cambio, imagen: $imagen )';
  }
}
