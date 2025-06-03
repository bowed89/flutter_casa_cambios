import '../../domain/model/moneda_model.dart';
import '../../domain/repositories/i_moneda_repository.dart';

class MonedaService {
  final IMonedaRepository repo;

  MonedaService(this.repo);

  Future<List<Moneda>> getAllMonedas() => repo.getAll();
  Future<void> addMoneda(Moneda moneda) => repo.insert(moneda);
  Future<void> updateMoneda(Moneda moneda) => repo.update(moneda);
  Future<void> deleteMoneda(int id) => repo.delete(id);
}
