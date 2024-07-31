import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return sqlite3.open(path);
  }

  Future<void> createTable(Database db) async {
    const orderTable = '''
    CREATE TABLE IF NOT EXISTS orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      isCancelledByUser BOOLEAN NOT NULL,
      orderId TEXT NOT NULL,
      customerRefId TEXT,
      merchantId TEXT NOT NULL
    )
    ''';

    db.execute(orderTable);
  }

  Future<void> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    await createTable(db);
    db.execute(
      'INSERT INTO orders (isCancelledByUser, orderId, customerRefId, merchantId) VALUES (?, ?, ?, ?)',
      [
        order['isCancelledByUser'],
        order['orderId'],
        order['customerRefId'],
        order['merchantId']
      ],
    );
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final db = await database;
    final result = db.select('SELECT * FROM orders');
    return result
        .map((row) => {
              'isCancelledByUser': row['isCancelledByUser'],
              'orderId': row['orderId'],
              'customerRefId': row['customerRefId'],
              'merchantId': row['merchantId'],
            })
        .toList();
  }

  Future<String> getDatabasesPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> databaseExists(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    return File(path).exists();
  }
}
