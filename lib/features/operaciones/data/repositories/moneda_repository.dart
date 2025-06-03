import '../../../../database/db_helper.dart';
import '../../../operaciones/domain/model/moneda_model.dart';
import '../../../operaciones/domain/repositories/i_moneda_repository.dart';

class MonedaRepository implements IMonedaRepository {
  @override
  Future<List<Moneda>> getAll() async {
    final db = await DBHelper.database;
    final result = await db.query('moneda');
    return result.map((e) => Moneda.fromMap(e)).toList();
  }

  @override
  Future<void> insert(Moneda moneda) async {
    final db = await DBHelper.database;
    await db.insert('moneda', moneda.toMap());
  }

  @override
  Future<void> update(Moneda moneda) async {
    final db = await DBHelper.database;
    await db.update(
      'moneda',
      moneda.toMap(),
      where: 'id = ?',
      whereArgs: [moneda.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await DBHelper.database;
    await db.delete('moneda', where: 'id = ?', whereArgs: [id]);
  }
}
