import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'Readings.dart';

class DbHelper {
  Database db;
  static const String dbName = 'YOCal_Master.db';
  static const String versionFilename = 'version.txt';
  HttpClient httpClient;

  Future<String> get _docPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _versionFile async {
    final path = await _docPath;
    return File('$path/$versionFilename');
  }

  Future<String> get _dbPath async {
    return join(await getDatabasesPath(), dbName);
  }

  Future init() async {
    if (db != null) {
      return;
    }

    httpClient = new HttpClient();

    if (!await databaseExists(await _dbPath)) {
      // First launch
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      await Directory(dirname(await _dbPath)).create(recursive: true);

      // Copy DB from asset
      ByteData data = await rootBundle.load(join("assets", dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(await _dbPath).writeAsBytes(bytes, flush: true);
    }

    if (!await (await _versionFile).exists()) {
      // First launch
      ByteData data = await rootBundle.load(join("assets", versionFilename));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      (await _versionFile).writeAsBytes(bytes, flush: true);
    }

    // Update DB
    _updateDb();

    // open the database
    // var db = await openDatabase(path, readOnly: true);
    this.db = await openDatabase(await _dbPath, readOnly: true);

    // /* Debug */
    // (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
    //   print(row.values);
    // });
  }

  Future<bool> _isUpToDate() async {
    const url = 'http://yorkorthodox.org/appstore/$versionFilename';
    var request = await httpClient.getUrl(Uri.parse(url));
    // 4 second timeout
    try {
      var response = await request.close().timeout(const Duration(seconds: 4));
      var bytes = await consolidateHttpClientResponseBytes(response);
      final currentVersion = int.parse(utf8.decode(bytes));

      // Version in the app
      final appVersionFile = await _versionFile;
      final String version = await appVersionFile.readAsString();
      final appDbVersion = int.parse(version);

      print('Version number check: $currentVersion == $appDbVersion ?');
      return (currentVersion == appDbVersion);
    } on TimeoutException {
      // Don't try to update
      print('Offline');
      return true;
    }
  }

  void _updateDb() async {
    if (await _isUpToDate()) {
      print('Database is up to date');
      return;
    }

    print('Updating database...');
    const dbUrl = 'http://yorkorthodox.org/appstore/$dbName';
    var request = await httpClient.getUrl(Uri.parse(dbUrl));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    final dbFile = new File(await _dbPath);
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
    await dbFile.create();
    await dbFile.writeAsBytes(bytes, flush: true);

    const versionFileUrl = 'http://yorkorthodox.org/appstore/$versionFilename';
    request = await httpClient.getUrl(Uri.parse(versionFileUrl));
    response = await request.close();
    bytes = await consolidateHttpClientResponseBytes(response);
    if (await (await _versionFile).exists()) {
      await (await _versionFile).delete();
    }
    await (await _versionFile).create();
    await (await _versionFile).writeAsBytes(bytes, flush: true);

    print('Done');
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
