import 'package:casa_de_cambios/features/operaciones/domain/model/compra_detallada_model.dart';

import '../../domain/model/compra_model.dart';
import '../../domain/repositories/i_compra_repository.dart';

class CompraService {
  final ICompraRepository repository;

  CompraService(this.repository);

  Future<List<Compra>> getAllCompras() => repository.getAll();
  Future<List<CompraDetallada>> getCompraDetallada() => repository.getCompraDetallada();
  Future<void> addCompra(Compra compra) => repository.insert(compra);
  Future<void> updateCompra(Compra compra) => repository.update(compra);
  Future<void> deleteCompra(int id) => repository.delete(id);
}
