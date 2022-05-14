import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final _dbName = 'myDatabase.db';
  final _dbVersion = 1;
  final _tableName = 'mytable';

  //sql table column names
  final columnId = '_id';
  final columnName = '_name';

  // singelton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDatabase();
      return _database;
    }
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    create Table $_tableName(
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $columnName TEXT NOT NULL)
''');
  }

  Future<int?> insert(Map<String, dynamic> row) async {
    //call db first
    //(question surrounding how to call a getter)
    Database? db = await instance.database;
    return await db?.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>?> queryAll() async {
    Database? db = await instance.database;
    return db?.query(_tableName, orderBy: columnId);
  }

  Future update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db
        ?.update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future delete(int id) async {
    Database? db = await instance.database;
    return await db
        ?.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}

// class SQLHelper {
//   static Future<void> createTables(Database database) async {
//     await database.execute("""CREATE TABLE items(
//         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//         title TEXT,
//         description TEXT,
//         createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
//       )
//       """);
//   }
// // id: the id of a item
// // title, description: name and description of your activity
// // created_at: the time that the item was created. It will be automatically handled by SQLite

//   static Future<Database> db() async {
//     return openDatabase(
//       'kindacode.db',
//       version: 1,
//       onCreate: (Database database, int version) async {
//         await createTables(database);
//       },
//     );
//   }

//   // Create new item (journal)
//   static Future<int> createItem(String title, String? descrption) async {
//     final db = await SQLHelper.db();

//     final data = {'title': title, 'description': descrption};
//     final id = await db.insert('items', data,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//     return id;
//   }

//   // Read all items (journals)
//   static Future<List<Map<String, dynamic>>> getItems() async {
//     final db = await SQLHelper.db();
//     return db.query('items', orderBy: "id");
//   }

//   // Read a single item by id
//   // The app doesn't use this method but I put here in case you want to see it
//   static Future<List<Map<String, dynamic>>> getItem(int id) async {
//     final db = await SQLHelper.db();
//     return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
//   }

//   // Update an item by id
//   static Future<int> updateItem(
//       int id, String title, String? descrption) async {
//     final db = await SQLHelper.db();

//     final data = {
//       'title': title,
//       'description': descrption,
//       'createdAt': DateTime.now().toString()
//     };

//     final result =
//         await db.update('items', data, where: "id = ?", whereArgs: [id]);
//     return result;
//   }

//   // Delete
//   static Future<void> deleteItem(int id) async {
//     final db = await SQLHelper.db();
//     try {
//       await db.delete("items", where: "id = ?", whereArgs: [id]);
//     } catch (err) {
//       // ignore: avoid_print
//       print("Something went wrong when deleting an item: $err");
//     }
//   }
// }
