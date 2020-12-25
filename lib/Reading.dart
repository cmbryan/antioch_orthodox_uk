class Reading {
  String lect;
  String text;

  Reading.fromMap(Map<String, dynamic> map) {
    lect = map['lect_1'];
    text = map['text_1'];
  }
}
