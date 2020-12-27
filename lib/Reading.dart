class Reading {
  String date;
  String lect;
  String text;

  Reading.fromMap(Map<String, dynamic> map) {
    lect = map['date'];
    lect = map['lect_1'];
    text = map['text_1'];
  }
}
