class Venta {
  final int? id;
  final int idMoneda;
  final int idUsuario;
  final double montoVenta;

  Venta({
    this.id,
    required this.idMoneda,
    required this.idUsuario,
    required this.montoVenta,
  });

  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      id: map['id'],
      idMoneda: map['id_moneda'],
      idUsuario: map['id_usuario'],
      montoVenta: map['monto_venta'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_moneda': idMoneda,
      'id_usuario': idUsuario,
      'monto_venta': montoVenta,
    };
  }
}
