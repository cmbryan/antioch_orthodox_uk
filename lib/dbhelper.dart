import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Readings.dart';

class DbHelper {
  Database db;

  Future init() async {
    if (db != null) {
      return;
    }

    final dbName = 'YOCal_Master.db';
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      await Directory(dirname(path)).create(recursive: true);

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", dbName));
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
  }

  Future<Readings> getEpistleReadings(DateTime date) async {
    // Convert DateTime to String
    final format = DateFormat('yyyy-MM-dd');
    final dateStr = format.format(date);

    // Map of column names to values
    final List<Map<String, dynamic>> map = await this.db.rawQuery('''
      SELECT
        ord, month, year,
        lect_1, text_1, lect_2, text_2,
        class_5, british
      FROM yocal_lections lect
      JOIN yocal_main
        ON a_code = lect.code
        OR g_code = lect.code
        OR c_code = lect.code
      WHERE date = "$dateStr"
    ''');
    return Readings.fromMaps(map);
  }
}
