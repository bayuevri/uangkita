import 'package:sqflite/sqflite.dart';
import 'package:uang_kita/models/bill_model.dart';
import 'package:uang_kita/models/category_type_model.dart';
import 'package:uang_kita/repositories/interfaces/interface_bill_repository.dart';
import 'package:uang_kita/utils/model_utils.dart';

class BillRepository extends IBillRepository {
  static const tableName = 'bills';

  @override
  Future<void> createTable(Database db) {
    return db.execute(
        'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount INTEGER, due_date DATETIME, category TEXT)');
  }

  @override
  Future<void> delete(Database db, int id) {
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Bill>> findAll(Database db) {
    return db.query(tableName, orderBy: 'date DESC').then((records) {
      return records.map((record) => ModelUtils.mapToBill(record)).toList();
    });
  }

  @override
  Future<void> insert(Database db, Map<String, dynamic> data) {
    // validate data
    if (data['title'] == null ||
        data['category'] == null ||
        data['amount'] == null ||
        data['due_date'] == null) {
      throw Exception('Field title, category, amount, dan due_date kosong');
    }

    final category = data['category'] as CategoryType;

    data['category'] = category.name;

    return db.insert(tableName, data);
  }

  @override
  Future<void> update(Database db, int id, Map<String, dynamic> data) {
    // validate data
    if (data['title'] == null ||
        data['category'] == null ||
        data['amount'] == null ||
        data['due_date'] == null) {
      throw Exception('Field title, category, amount, dan due_date kosong');
    }

    final category = data['category'] as CategoryType;

    data['category'] = category.name;

    return db.update(tableName, data, where: 'id = ?', whereArgs: [id]);
  }
}
