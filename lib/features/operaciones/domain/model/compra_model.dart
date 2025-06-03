class Compra {
  final int? id;
  final int idVenta;
  final int idUsuario;
  final double montoCompra;
  final double totalPagar;
  final String? imagen;

  Compra({
    this.id,
    required this.idVenta,
    required this.idUsuario,
    required this.montoCompra,
    required this.totalPagar,
    this.imagen,
  });

  factory Compra.fromMap(Map<String, dynamic> map) {
    return Compra(
      id: map['id'],
      idVenta: map['id_venta'],
      idUsuario: map['id_usuario'],
      montoCompra: map['monto_compra'],
      totalPagar: map['total_pagar'],
      imagen: map['imagen'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_venta': idVenta,
      'id_usuario': idUsuario,
      'monto_compra': montoCompra,
      'total_pagar': totalPagar,
      'imagen': imagen,
    };
  }

  @override
  String toString() {
    return 'Compra(id: $id, idVenta: $idVenta, idUsuario: $idUsuario, montoCompra: $montoCompra, totalPagar: $totalPagar,imagen: $imagen)';
  }
}
