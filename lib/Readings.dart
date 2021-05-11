class Readings {
  String dateStr;
  List<String> epistleTitles, gospelTitles;
  List<String> epistleReadings, gospelReadings;
  String saintsGeneral, saintsBritish, majorCommem;

  /// Each element of maps represents a row in the DB.
  /// Each element of a map is column -> value.
  /// Nb. Each row may have both an Epistle and Gospel.
  Readings.fromMap(Map<String, dynamic> map) {
    /* Date */
    dateStr = map['date_str'];

    /* Readings */
    epistleTitles = <String>[];
    gospelTitles = <String>[];
    epistleReadings = <String>[];
    gospelReadings = <String>[];

    for (String key in ['a_lect_1', 'a_lect_2', 'c_lect_1']) {
      if (map[key] != '') {
        epistleTitles.add(map[key]);
      }
    }

    for (String key in ['a_text_1', 'a_text_2', 'c_text_1']) {
      if (map[key] != '') {
        epistleReadings.add(map[key]);
      }
    }

    // for (String key in ['g_lect', 'c_lect_2']) {
    if (map['g_lect'] != '') {
      gospelTitles.add(map['g_lect']);
      gospelReadings.add(map['g_text']);
    }
    // }

    /* Saints */
    saintsGeneral = map['general_commem'];
    saintsBritish = map['british_commem'];
    majorCommem = map['major_commem'];
  }

  String formatTitles() {
    String result = '';
    for (final title in epistleTitles) {
      result += title + '<br/>';
    }
    for (final title in gospelTitles) {
      result += title + '<br/>';
    }
    return result;
  }

  /// Return all the readings as a single block of html.
  String formatReadings() {
    String result = '';
    for (final reading in epistleReadings) {
      result += reading + '<br/>';
    }
    for (final reading in gospelReadings) {
      result += reading + '<br/>';
    }
    return result;
  }

  /// Return all the readings as a single block of html.
  String formatSaints() {
    return saintsGeneral + '<br/>' + saintsBritish;
  }
}
