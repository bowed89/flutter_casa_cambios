import 'package:casa_de_cambios/features/operaciones/domain/model/moneda_model.dart';

abstract class IMonedaRepository {
  Future<List<Moneda>> getAll();
  Future<void> insert(Moneda moneda);
  Future<void> update(Moneda moneda);
  Future<void> delete(int id);
}
