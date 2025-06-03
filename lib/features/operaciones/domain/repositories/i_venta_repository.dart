
import 'package:casa_de_cambios/features/operaciones/domain/model/venta_con_moneda.dart';
import 'package:casa_de_cambios/features/operaciones/domain/model/venta_model.dart';

abstract class IVentaRepository {
  Future<List<Venta>> getAll();
  Future<List<VentaConMoneda>> getVentasConMoneda();
  Future<void> insert(Venta venta);
  Future<void> update(Venta venta);
  Future<void> delete(int id);
}
