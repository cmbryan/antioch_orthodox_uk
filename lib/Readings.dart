class Readings {
  String ordinand, month;
  int year;
  List<String> epistleTitles, gospelTitles;
  List<String> epistleReadings, gospelReadings;
  String saintsGeneral, saintsBritish;

  /// Each element of maps represents a row in the DB.
  /// Each element of a map is column -> value.
  /// Nb. Each row may have both an Epistle and Gospel.
  Readings.fromMaps(List<Map<String, dynamic>> maps) {
    /* Date */
    // It is assumed that every row belongs to the same day
    ordinand = maps.first['ord'];
    month = maps.first['month'];
    year = maps.first['year'];

    /* Readings */
    epistleTitles = List<String>();
    gospelTitles = List<String>();
    epistleReadings = List<String>();
    gospelReadings = List<String>();
    for (final map in maps) {
      // Epistle?
      if (map['lect_1'] != null) {
        epistleTitles.add(map['lect_1']);
        epistleReadings.add(map['text_1']);
      }
      // Gospel?
      if (map['lect_2'] != null) {
        gospelTitles.add(map['lect_2']);
        gospelReadings.add(map['text_2']);
      }
    }

    /* Saints */
    saintsGeneral = maps.first['class_5'];
    saintsBritish = maps.first['british'];
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
