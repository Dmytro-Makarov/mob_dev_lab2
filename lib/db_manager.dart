import 'package:mob_dev_lab2/oblast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> populateDatabase(DBManager dbManager) async {
  var length = 0;
  dbManager.oblasts().then((value) => {
    length = value.length
  });
  if (length > 0) {
    var db = await dbManager.database;
    deleteDatabase(db.path);
    var database = openDatabase(
      db.path,
      // When the database is first created, create a table.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE oblasts(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, population INTEGER, area REAL, oblastCenter TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,);
    dbManager.database = database;
  }

  dbManager.insertOblast(Oblast(name: "Львівська", population: 2478133, area: 21831.97, oblastCenter: "Львів"));
  dbManager.insertOblast(Oblast(name: "Чернівецька ", population: 890457, area: 8097.0, oblastCenter: "Чернівці"));
  dbManager.insertOblast(Oblast(name: "Кіровоградська ", population: 	903712, area: 24588.0, oblastCenter: "Кропивницький"));
  dbManager.insertOblast(Oblast(name: "Чернігівська ", population: 959315, area: 31865.0, oblastCenter: "Чернігів"));
  dbManager.insertOblast(Oblast(name: "Херсонська ", population: 1001598, area: 28461.0, oblastCenter: "Херсон"));
  dbManager.insertOblast(Oblast(name: "Волинська ", population: 1021356, area: 20143.0, oblastCenter: "Луцьк"));
  dbManager.insertOblast(Oblast(name: "Тернопільська ", population: 1021713, area: 13823.0, oblastCenter: "Тернопіль"));
  dbManager.insertOblast(Oblast(name: "Одеська ", population: 2351392, area: 33310.0, oblastCenter: "Одеса"));

}

class DBManager {
  Future<Database> database;

  DBManager(this.database);
  
  static Future<DBManager> init(String dbName) async {
        var database = openDatabase(
          join(await getDatabasesPath(), '$dbName.db'),

          // When the database is first created, create a table.
          onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          return db.execute(
          'CREATE TABLE oblasts(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, population INTEGER, area REAL, oblastCenter TEXT)',
          );
          },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,);

        return DBManager(database);
  }

  // Define a function that inserts oblast into the database
  Future<void> insertOblast(Oblast oblast) async {
    // Get a reference to the database.
    final db = await database;
    // Insert the Oblast into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'oblasts',
      oblast.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the oblasts from the oblasts table.
  Future<List<Oblast>> oblasts() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Oblasts.
    final List<Map<String, dynamic>> maps = await db.query('oblasts');

    // Convert the List<Map<String, dynamic> into a List<Oblast>.
    return List.generate(maps.length, (i) {
      return Oblast(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        population: maps[i]['population'] as int,
        area: maps[i]['area'] as double,
        oblastCenter: maps[i]['oblastCenter'] as String,
      );
    });
  }

  // A method that retrieves oblasts with pop smaller than given from the oblasts table.
  Future<List<Oblast>> getOblastsWithPopulationLimit(int populationLimit) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Oblasts.
    final List<Map<String, dynamic>> maps =
      await db.query(
        'oblasts',
        where: 'id = ? AND population <= ?',
        whereArgs: ['id', populationLimit]
      );

    var list = List.generate(maps.length, (i) {
      return Oblast(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        population: maps[i]['population'] as int,
        area: maps[i]['area'] as double,
        oblastCenter: maps[i]['oblastCenter'] as String,
      );
    });

    var newList = <Oblast>[];

    newList.addAll(list.where((element) => element.population < populationLimit));

    // Convert the List<Map<String, dynamic> into a List<Oblast>.
    return newList;
  }

  // A method that retrieves oblasts with pop smaller than given from the oblasts table.
  Future<double> countAveragePopulation() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Oblasts.
    final List<Map<String, dynamic>> maps = await db.query('oblasts');

    // Convert the List<Map<String, dynamic> into a List<Oblast>.
    final oblasts = List.generate(maps.length, (i) {
      return Oblast(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        population: maps[i]['population'] as int,
        area: maps[i]['area'] as double,
        oblastCenter: maps[i]['oblastCenter'] as String,
      );
    });

    double totalPop = 0.0;

    for (final oblast in oblasts) {
      totalPop += oblast.population;
    }
    return totalPop / oblasts.length;
  }

  Future<void> updateOblast(Oblast oblast) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'oblasts',
      oblast.toMap(),
      // Ensure that the Oblast has a matching id.
      where: 'id = ?',
      // Pass the Oblast's id as a whereArg to prevent SQL injection.
      whereArgs: [oblast.id],
    );
  }

  Future<void> deleteOblast(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Oblast from the database.
    await db.delete(
      'oblasts',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Oblast's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}