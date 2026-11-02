import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';

class ExpenseRepository {
  static final ExpenseRepository instance = ExpenseRepository._init();
  static Database? _database;

  ExpenseRepository._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS expenses');
        await _createDB(db, newVersion);
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    final initialExpenses = [
      Expense(
        name: 'Ăn uống',
        cost: 150000,
        type: 'Sinh hoạt',
        date: '29/10/2026',
      ),
      Expense(
        name: 'Di chuyển',
        cost: 50000,
        type: 'Đi lại',
        date: '28/10/2026',
      ),
      Expense(
        name: 'Mua sách',
        cost: 200000,
        type: 'Học tập',
        date: '27/10/2026',
      ),
      Expense(
        name: 'Mua sắm',
        cost: 1500000,
        type: 'Sinh hoạt',
        date: '25/10/2026',
      ),
      Expense(
        name: 'Khám bệnh',
        cost: 3550000,
        type: 'Sức khỏe',
        date: '22/10/2026',
      ),
    ];

    for (final expense in initialExpenses) {
      await db.insert('expenses', expense.toMap());
    }
  }

  Future<List<Expense>> getExpenses() async {
    final db = await instance.database;
    final result = await db.query('expenses', orderBy: 'id ASC');
    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await instance.database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }
}
