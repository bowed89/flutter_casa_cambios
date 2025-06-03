import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<void> borrarBaseDeDatos() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'casa_cambios.db');
    await deleteDatabase(path);
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'casa_cambios.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        // Tabla USUARIOS
        await db.execute('''
    CREATE TABLE usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      rol TEXT NOT NULL
    )
  ''');

        // Seeder: usuario admin por defecto
        await db.insert('usuarios', {
          'email': 'admin@gmail.com',
          'password': 'admin123',
          'rol': 'admin',
        });

        // Tabla MONEDA
        await db.execute('''
    CREATE TABLE moneda (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      tipo_cambio REAL NOT NULL
    )
  ''');

        // Tabla VENTA
        await db.execute('''
    CREATE TABLE venta (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_moneda INTEGER NOT NULL,
      id_usuario INTEGER NOT NULL,
      monto_venta REAL NOT NULL,
      FOREIGN KEY (id_moneda) REFERENCES moneda (id),
      FOREIGN KEY (id_usuario) REFERENCES usuarios (id)
    )
  ''');

        // Tabla COMPRA
        await db.execute('''
    CREATE TABLE compra (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_venta INTEGER NOT NULL,
      id_usuario INTEGER NOT NULL,
      monto_compra REAL NOT NULL,
      total_pagar REAL NOT NULL,
      imagen TEXT NOT NULL,
      FOREIGN KEY (id_venta) REFERENCES venta (id),
      FOREIGN KEY (id_usuario) REFERENCES usuarios (id)
    )
  ''');
      },
    );
  }
}
