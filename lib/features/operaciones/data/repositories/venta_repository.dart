import 'package:casa_de_cambios/features/operaciones/domain/model/venta_con_moneda.dart';

import '../../../../database/db_helper.dart';
import '../../../operaciones/domain/model/venta_model.dart';
import '../../../operaciones/domain/repositories/i_venta_repository.dart';

class VentaRepository implements IVentaRepository {
  @override
  Future<List<Venta>> getAll() async {
    final db = await DBHelper.database;
    final result = await db.query('venta');
    return result.map((e) => Venta.fromMap(e)).toList();
  }

  @override
  Future<void> insert(Venta venta) async {
    final db = await DBHelper.database;
    await db.insert('venta', venta.toMap());
  }

  @override
  Future<void> update(Venta venta) async {
    final db = await DBHelper.database;
    await db.update(
      'venta',
      venta.toMap(),
      where: 'id = ?',
      whereArgs: [venta.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await DBHelper.database;
    await db.delete('venta', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<VentaConMoneda>> getVentasConMoneda() async {
    final db = await DBHelper.database;

    final result = await db.rawQuery('''
    SELECT venta.id, venta.monto_venta, moneda.nombre AS nombre_moneda, moneda.tipo_cambio
    FROM venta
    INNER JOIN moneda ON venta.id_moneda = moneda.id
  ''');

    return result.map((e) => VentaConMoneda.fromMap(e)).toList();
  }
}
 