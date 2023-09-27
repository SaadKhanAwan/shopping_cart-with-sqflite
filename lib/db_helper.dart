import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:shopping_cart_app/model.dart';
import 'package:path/path.dart';

class DB_helper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initdatabase();
    }
    return _db!;
  }

  initdatabase() async {
    io.Directory documentdirectory = await getApplicationDocumentsDirectory();
    String path = join(documentdirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _oncreate);
    return db;
  }

// here table is made for daatbase
  _oncreate(Database db, int version) async {
    await db.execute('''CREATE TABLE cart(
        id INTEGER PRIMARY KEY, 
        productid VARCHAR UNIQUE,
        productname TEXT,
        unit_tag TEXT,
        image TEXT,
        initail_price INTEGER,
        product_price INTEGER,
        quantity INTEGER
        
        )
        ''');
  }

  // this is to insert data in database
  Future<cart> insert(cart cart) async {
    var dbClient = await db;
    await dbClient!.insert("cart", cart.toMap());
    return cart;
  }

  // this is to get data in database
  Future<List<cart>> Get_Cart_list() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cart');
    return queryResult.map((e) => cart.formMap(e)).toList();
  }

  // this is to insert dat in database
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('cart', where: 'id =?', whereArgs: [id]);
  }

  // this is to update data in database which increse and decrse price am=nd amount of products
  Future<int> updateQuantity(cart CArt) async {
    var dbClient = await db;
    return await dbClient!
        .update('cart', CArt.toMap(), where: 'id =?', whereArgs: [CArt.id]);
  }
}
