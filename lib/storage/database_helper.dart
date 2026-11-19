import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/electricity_bill.dart';

class DatabaseHelper {

  static Database? _database;

  // Get database instance
  static Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  // Initialize database
  static Future<Database> _initDatabase() async {

    String databasePath = await getDatabasesPath();

    String path = join(
      databasePath,
      'electricity_bills.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );

  }

  // Create table
  static Future<void> _createDatabase(
      Database db,
      int version) async {

    await db.execute('''
      CREATE TABLE electricity_bills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        consumerNumber TEXT,
        consumerName TEXT,
        billMonth TEXT,
        unitsConsumed INTEGER,
        billAmount REAL,
        dueDate TEXT,
        paid INTEGER
      )
    ''');

  }

  static Future<int> insertBill(ElectricityBill bill) async {

    final db = await database;

    return await db.insert(
      'electricity_bills',
      bill.toMap(),
    );



  }

  static Future<List<ElectricityBill>> getAllBills() async {

    final db = await database;

    final List<Map<String, dynamic>> maps =
    await db.query('electricity_bills');

    return List.generate(
      maps.length,
          (index) {
        return ElectricityBill.fromMap(maps[index]);
      },
    );

  }

  static Future<int> updateBill(ElectricityBill bill) async {

    final db = await database;

    return await db.update(
      'electricity_bills',
      bill.toMap(),
      where: 'id = ?',
      whereArgs: [bill.id],
    );

  }static Future<int> deleteBill(int id) async {
    final db = await database;

    return await db.delete(
      'electricity_bills',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



}