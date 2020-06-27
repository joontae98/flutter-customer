import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:customer_list/model/model.dart';
import 'package:path_provider/path_provider.dart';

const kTableCustomers = 'customers';
const kDatabaseVersion = 1;
const kDatabaseName = 'customers.db';
const kSQLCreateStatement = '''
CREATE TABLE $kTableCustomers (
id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
price TEXT NOT NULL,
status BIT
)''';
class DB{
  DB._();
  static final DB _db = DB._();
  factory DB() => _db;

  Database _database;

  Future<Database> get database async {
    // ?? = null 의 경우
    return _database ?? await initDB();
  }
  Future<Database> initDB() async {
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path, kDatabaseName);

    return await openDatabase(path, version: kDatabaseVersion,
        onCreate: (Database db, int version) async {
          await db.execute(kSQLCreateStatement);
        });
  }
  createCustomer(Customer customer) async {
    final db = await database;
    await db.insert(kTableCustomers, customer.toMapAutoID());
  }
  deleteDoneCustomers({bool status = true}) async {
    final db = await database;
    await db.delete(kTableCustomers, where: 'status=?', whereArgs: [status]);
  }
  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    var res = await db.query(kTableCustomers);
    List<Customer> list = res.isNotEmpty ? res.map((c) => Customer.fromMap(c)).toList() : [];
    return list;
  }

  statusCustomer(Customer customer) async {
    final db = await database;
    Customer status = Customer(
        id: customer.id,
        name: customer.name,
        price: customer.price,
        status: !customer.status);
    var res = await db.update(kTableCustomers, status.toMap(),
        where: "id = ?", whereArgs: [customer.id]);
  }

}