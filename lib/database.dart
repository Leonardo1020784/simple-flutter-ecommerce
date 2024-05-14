import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_ffi

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    // Initialize sqflite ffi
    sqfliteFfiInit(); // This line initializes SQFlite FFI

    // Set the databaseFactory to use FFI implementation
    databaseFactory = databaseFactoryFfi;

    String path = await getDatabasesPath();
    return await openDatabase(join(path, 'your_database_name.db'), version: 1,
        onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
       CREATE TABLE categories(
         id INTEGER PRIMARY KEY,
         name TEXT
       )
     ''');

    await db.execute('''
       CREATE TABLE products(
         id INTEGER PRIMARY KEY,
         categoryId INTEGER,
         name TEXT,
         price REAL,
         quantity INTEGER,
         FOREIGN KEY(categoryId) REFERENCES categories(id)
       )
     ''');
  }

  static Future<void> insertCategory(String name) async {
    final db = await database;
    await db.insert(
      'categories',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  static Future<void> insertProduct(int categoryId, String name, double price) async {
    final db = await database;
    await db.insert(
      'products',
      {'categoryId': categoryId, 'name': name, 'price': price, 'quantity': 0}, // Initialize quantity to 0
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  static Future<void> updateProductQuantity(int productId, int quantityChange) async {
    final db = await database;
    List<Map<String, dynamic>> product = await db.query('products', where: 'id = ?', whereArgs: [productId]);
    if (product.isNotEmpty && product[0]['quantity'] != null) {
      int currentQuantity = product[0]['quantity'];
      int newQuantity = currentQuantity + quantityChange; // Update quantity based on quantityChange
      if (newQuantity < 0) {
        newQuantity = 0; // Ensure quantity doesn't go below 0
      }
      await db.update('products', {'quantity': newQuantity}, where: 'id = ?', whereArgs: [productId]);
    }
  }




  static Future<List<Map<String, dynamic>>> getProducts(int categoryId) async {
    final db = await database;
    return await db.query('products', where: 'categoryId = ?', whereArgs: [categoryId]);
  }

  static Future<List<Map<String, dynamic>>> getAllBasketItems() async {
    final db = await database;
    return await db.query('products'); // You may need to adjust this query according to your database schema
  }
}
