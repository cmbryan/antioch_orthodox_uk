import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'orm.dart';

class DbHelper {
  Database db;

  Future init() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "readings.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      await Directory(dirname(path)).create(recursive: true);

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "readings.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    // open the database
    // var db = await openDatabase(path, readOnly: true);
    this.db = await openDatabase(path, readOnly: true);

    // /* Debug */
    // (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
    //   print(row.values);
    // });
    // (await db.query('readings', columns: ['code', 'text'])).forEach((row) {
    //   print(row.values);
    // });
  }

  Future<List<Reading>> getReadings() async {
    final List<Map<String, dynamic>> maps =
        await this.db.query('readings', columns: ['code', 'text']);
    return List.generate(maps.length, (i) {
      return Reading(
        code: maps[i]['code'],
        text: maps[i]['text'],
      );
    });
  }
}
