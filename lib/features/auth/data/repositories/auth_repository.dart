import 'package:casa_de_cambios/features/auth/domain/repositories/i_auth_repository.dart';

import '../../../../database/db_helper.dart';
import '../../domain/model/auth_model.dart';

class AuthRepository implements IAuthRepository {
  @override
  Future<void> registerUser(Usuarios usuario) async {
    final db = await DBHelper.database;
    await db.insert('usuarios', usuario.toMap());
  }

  @override
  Future<Usuarios?> login(String email, String password) async {
    final db = await DBHelper.database;
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return Usuarios.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<List<Usuarios>> getAll() async {
    final db = await DBHelper.database;
    final result = await db.query('usuarios');
    return result.map((e) => Usuarios.fromMap(e)).toList();
  }

  @override
  Future<void> updateUser(Usuarios usuario) async {
    final db = await DBHelper.database;
    await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await DBHelper.database;
    await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }
}
