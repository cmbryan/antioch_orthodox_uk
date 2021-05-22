import 'dart:convert';

import 'package:http/http.dart' as http;

class DayInfo {
  String dateStr;
  final Map<String, String> epistles = {},
      gospel = {},
      commemEpistles = {},
      commemGospels = {},
      extras = {};
  bool isCommemorationEpistle, isCommemorationGospel;
  String saintsGeneral, saintsBritish, majorCommem;

  /// Each element of maps represents a row in the DB.
  /// Each element of a map is column -> value.
  /// Nb. Each row may have both an Epistle and Gospel.
  DayInfo.fromMap(Map<String, dynamic> map) {
    /* Date */
    dateStr = map['date_str'];

    isCommemorationEpistle = (map['is_comm_apos'] != 1);
    isCommemorationGospel = (map['is_comm_gosp'] != 1);

    /* 'Normal' Readings */
    epistles[map['a_lect_1']] = map['a_text_1'];
    if (!_nullOrEmpty(map['a_lect_2'])) {
      epistles[map['a_lect_2']] = map['a_text_2'];
    }
    gospel[map['g_lect']] = map['g_text'];

    /* Commemorations */
    if (!_nullOrEmpty(map['c_lect_1'])) {
      commemEpistles[map['c_lect_1']] = map['c_text_1'];
    }
    if (!_nullOrEmpty(map['c_lect_2'])) {
      commemGospels[map['c_lect_2']] = map['c_text_2'];
    }

    /* "Extra" */
    if (!_nullOrEmpty(map['x_lect_1'])) {
      extras[map['x_lect_1']] = map['x_text_1'];
    }
    if (!_nullOrEmpty(map['x_lect_2'])) {
      extras[map['x_lect_2']] = map['x_text_2'];
    }

    /* Saints */
    saintsGeneral = map['general_commem'];
    saintsBritish = map['british_commem'];
    majorCommem = map['major_commem'];
  }

  String formatTitles() {
    String result = '';
    String tmp;
    var lineList = [];

    epistles.forEach((key, _) => lineList.add(key));
    tmp = lineList.join('; ');
    if (!isCommemorationEpistle) {
      tmp = '<b>$tmp</b>';
    }
    result += tmp;
    lineList = [];

    gospel.forEach((key, _) => lineList.add(key));
    tmp = lineList.join('; ');
    if (!isCommemorationGospel) {
      tmp = '<b>$tmp</b>';
    }
    result += '; $tmp';
    lineList = [];

    result += '<br/>';

    commemEpistles.forEach((key, _) => lineList.add(key));
    if (lineList.isNotEmpty) {
      tmp = lineList.join('; ');
      if (isCommemorationEpistle) {
        tmp = '<b>$tmp</b>';
      }
      result += '<i>For the commemoration: </i>$tmp';
      lineList = [];
    }

    commemGospels.forEach((key, _) => lineList.add(key));
    if (lineList.isNotEmpty) {
      tmp = lineList.join('; ');
      if (isCommemorationGospel) {
        tmp = '<b>$tmp</b>';
      }
      result += '; $tmp<br/>';
      lineList = [];
    }

    extras.forEach((key, _) => lineList.add(key));
    if (lineList.isNotEmpty) {
      result += lineList.join('; ') + '<br/>';
    }

    return result;
  }

  /// Return all the readings as a single block of html.
  String formatReadings() {
    String result = '';
    var contentList = [];

    epistles.forEach((_, value) => contentList.add(value));
    gospel.forEach((_, value) => contentList.add(value));
    result += contentList.join();
    contentList = [];

    commemEpistles.forEach((_, value) => contentList.add(value));
    commemGospels.forEach((_, value) => contentList.add(value));
    result += contentList.join();
    contentList = [];

    extras.forEach((_, value) => contentList.add(value));
    result += contentList.join();

    return result;
  }

  /// Return all the readings as a single block of html.
  String formatSaints() {
    return saintsGeneral + '<br/>' + saintsBritish;
  }
}

/// Create a Readings future for a given date
Future<DayInfo> fetchReadings(String dateStr) async {
  final response = await http
      .get(Uri.https('york-orthodox-db-serve.glitch.me', 'data/' + dateStr));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return DayInfo.fromMap(jsonDecode(response.body)[0]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

bool _nullOrEmpty(String data) {
  return data == null || data == '';
}
