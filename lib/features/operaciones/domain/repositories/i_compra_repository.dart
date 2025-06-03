import 'package:casa_de_cambios/features/operaciones/domain/model/compra_detallada_model.dart';
import 'package:casa_de_cambios/features/operaciones/domain/model/compra_model.dart';

abstract class ICompraRepository {
  Future<List<Compra>> getAll();
  Future<List<CompraDetallada>> getCompraDetallada();
  Future<void> insert(Compra compra);
  Future<void> update(Compra compra);
  Future<void> delete(int id);
}
