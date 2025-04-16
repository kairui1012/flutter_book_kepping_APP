import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BookKeepingData {
  final String id;

  final String year;
  final String month;
  final String date;
  final double amount;
  final String name;

  const BookKeepingData({
    required this.id,
    required this.amount,
    required this.year,
    required this.month,
    required this.date,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'year': year,
      'month': month,
      'date': date,
      'name': name,
    };
  }

  factory BookKeepingData.fromMap(Map<String, dynamic> map) {
    return BookKeepingData(
      id: map['id'],
      amount:
          map['amount'] is String
              ? double.tryParse(map['amount']) ?? 0.0
              : (map['amount'] as num).toDouble(),
      year: map['year'],
      month: map['month'],
      date: map['date'],
      name: map['name'],
    );
  }
}

Future<Database> getDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'bookkeeping.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE bookkeeping(id TEXT PRIMARY KEY, amount TEXT, year TEXT, month TEXT, date TEXT, name TEXT)',
      );
    },
    onUpgrade: (db, oldVersion, newVersion) {
      db.execute('DROP TABLE IF EXISTS bookkeeping');
      return db.execute(
        'CREATE TABLE bookkeeping(id TEXT PRIMARY KEY, amount TEXT, year TEXT, month TEXT, date TEXT, name TEXT)',
      );
    },
    version: 2,
  );
}

Future<void> insertBookkeepingData(BookKeepingData data) async {
  final db = await getDatabase();
  await db.insert(
    'bookkeeping',
    data.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateBookkeepingData(BookKeepingData data) async {
  final db = await getDatabase();
  await db.update(
    'bookkeeping',
    data.toMap(),
    where: 'id = ?',
    whereArgs: [data.id],
  );
}

Future<void> deleteBookkeepingData(String id) async {
  final db = await getDatabase();
  await db.delete('bookkeeping', where: 'id = ?', whereArgs: [id]);
}

Future<List<BookKeepingData>> getTodayBookkeepingData() async {
  final db = await getDatabase();
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  final date = now.day.toString().padLeft(2, '0');


  final List<Map<String, dynamic>> maps = await db.query(
    'bookkeeping',
    where: 'year = ? AND month = ? AND date = ?',
    whereArgs: [year, month, date],
  );

  if (maps.isEmpty) {
    return [];
  }

  return List.generate(maps.length, (i) {
    return BookKeepingData.fromMap(maps[i]);
  });
}

Future<double> getThisMonthTotalAmount() async {
  final db = await getDatabase();
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');

  final List<Map<String, dynamic>> maps = await db.query(
    'bookkeeping',
    where: 'year = ? AND month = ?',
    whereArgs: [year, month],
  );

  double total = 0.0;
  for (var map in maps) {
    total += double.tryParse(map['amount']) ?? 0.0;
  }
  return total;
}

Future<double> getThisMonthAverageDailyAmount() async {
  final db = await getDatabase();
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');

  final List<Map<String, dynamic>> maps = await db.query(
    'bookkeeping',
    where: 'year = ? AND month = ?',
    whereArgs: [year, month],
  );

  double total = 0.0;
  Set<String> uniqueDates = {};

  for (var map in maps) {
    total += double.tryParse(map['amount']) ?? 0.0;
    uniqueDates.add(map['date']);
  }

  if (uniqueDates.isEmpty) return 0.0;
  return total / uniqueDates.length;
}

Future<void> clearAllData() async {
  String path = join(await getDatabasesPath(), 'bookkeeping.db');
  Database db = await openDatabase(path);
  List<Map<String, dynamic>> tables = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table'",
  );
  for (var table in tables) {
    String tableName = table['name'];
    if (tableName != 'sqlite_sequence') {
      await db.delete(tableName);
    }
  }
  await db.close();
}

Future<List<BookKeepingData>> getAllBookkeepingData() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> maps = await db.query('bookkeeping');

  return List.generate(maps.length, (i) {
    return BookKeepingData.fromMap(maps[i]);
  });
}

Future<double> getTodayTotalAmount() async {
  final db = await getDatabase();
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  final date = now.day.toString().padLeft(2, '0');

  final List<Map<String, dynamic>> maps = await db.query(
    'bookkeeping',
    where: 'year = ? AND month = ? AND date = ?',
    whereArgs: [year, month, date],
  );

  double total = 0.0;
  for (var map in maps) {
    total += double.tryParse(map['amount']) ?? 0.0;
  }
  return total;
}
