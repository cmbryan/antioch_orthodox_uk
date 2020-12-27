class Readings {
  String ordinand;
  String month;
  int year;
  List<String> epistleReadings;
  List<String> gospelReadings;

  /// Each element of maps represents a row in the DB.
  /// Each element of a map is column -> value.
  /// Nb. Each row may have both an Epistle and Gospel.
  Readings.fromMaps(List<Map<String, dynamic>> maps) {
    // It is assumed that every row belongs to the same day
    ordinand = maps.first['ord'];
    month = maps.first['month'];
    year = maps.first['year'];

    epistleReadings = List<String>();
    gospelReadings = List<String>();
    for (final map in maps) {
      // Epistle?
      if (map['lect_1'] != null) {
        epistleReadings.add(map['text_1']);
      }
      // Gospel?
      if (map['lect_2'] != null) {
        gospelReadings.add(map['text_2']);
      }
    }
  }

  /// Return all the readings as a single block of html.
  String format() {
    String result = "";
    for (final reading in epistleReadings) {
      result += reading + "<br/>";
    }
    for (final reading in gospelReadings) {
      result += reading + "<br/>";
    }
    return result;
  }
}
