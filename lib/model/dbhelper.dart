import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uas/model/menu.dart';

class DBHelper {
  DBHelper._privatConstructor();
  static final DBHelper intance = DBHelper._privatConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'mylocaldatabase.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            ''' CREATE TABLE menus(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, img TEXT, harga DOUBLE, rating DOUBLE, deskripsi TEXT) ''');
      },
    );
  }

  Future<void> insertMenu(Menu menu) async {
    final db = await database;
    await db.insert('menus', menu.toMap());
  }

  Future<List<Menu>> getMenus() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('menus');
    return List.generate(maps.length, (i) {
      return Menu.fromMap(maps[i]);
    });
  }

  Future<Menu?> getMenuByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'menus',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Menu.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Menu?> getMenuById(int menuId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'menus',
      where: 'id = ?',
      whereArgs: [menuId],
    );
    if (maps.isNotEmpty) {
      return Menu.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateMenu(Menu menu) async {
    final db = await database;
    await db.update('menus', menu.toMap(),
        where: 'name = ?',
        whereArgs: [menu.name],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
