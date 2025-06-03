class VentaConMoneda {
  final int id;
  final double montoVenta;
  final double tipoCambio;
  final String nombreMoneda;

  VentaConMoneda({
    required this.id,
    required this.montoVenta,
    required this.nombreMoneda,
    required this.tipoCambio,
  });

  factory VentaConMoneda.fromMap(Map<String, dynamic> map) {
    return VentaConMoneda(
      id: map['id'],
      montoVenta: map['monto_venta'],
      nombreMoneda: map['nombre_moneda'],
      tipoCambio: map['tipo_cambio'],
    );
  }
}
