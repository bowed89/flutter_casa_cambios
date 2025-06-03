import 'package:casa_de_cambios/features/operaciones/domain/model/venta_con_moneda.dart';

import '../../domain/model/venta_model.dart';
import '../../domain/repositories/i_venta_repository.dart';

class VentaService {
  final IVentaRepository repository;

  VentaService(this.repository);

  Future<List<Venta>> getAllVentas() => repository.getAll();
  
  Future<List<VentaConMoneda>> getVentasConMoneda() => repository.getVentasConMoneda();

  Future<void> addVenta(Venta venta) => repository.insert(venta);
  Future<void> updateVenta(Venta venta) => repository.update(venta);
  Future<void> deleteVenta(int id) => repository.delete(id);
}
