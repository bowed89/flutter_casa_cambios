import 'package:casa_de_cambios/features/operaciones/domain/model/compra_detallada_model.dart';

import '../../../../database/db_helper.dart';
import '../../../operaciones/domain/model/compra_model.dart';
import '../../../operaciones/domain/repositories/i_compra_repository.dart';

class CompraRepository implements ICompraRepository {
  @override
  Future<List<Compra>> getAll() async {
    final db = await DBHelper.database;
    final result = await db.query('compra');
    return result.map((e) => Compra.fromMap(e)).toList();
  }

  @override
  Future<void> insert(Compra compra) async {
    final db = await DBHelper.database;
    await db.insert('compra', compra.toMap());
  }

  @override
  Future<void> update(Compra compra) async {
    final db = await DBHelper.database;
    await db.update(
      'compra',
      compra.toMap(),
      where: 'id = ?',
      whereArgs: [compra.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await DBHelper.database;
    await db.delete('compra', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<CompraDetallada>> getCompraDetallada() async {
    final db = await DBHelper.database;

    final result = await db.rawQuery('''
    SELECT compra.id, compra.total_pagar, compra.imagen,compra.id_usuario, compra.monto_compra, moneda.nombre AS nombre_moneda, moneda.tipo_cambio
    FROM compra
    INNER JOIN venta ON compra.id_venta = venta.id
    INNER JOIN moneda ON venta.id_moneda = moneda.id
    ''');

    return result.map((e) => CompraDetallada.fromMap(e)).toList();
  }
}
