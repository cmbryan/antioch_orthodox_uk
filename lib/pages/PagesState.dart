import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../DayInfo.dart';
import 'MainPage.dart';
import 'ReadingsPage.dart';
import 'SaintsPage.dart';

class AppPages extends StatefulWidget {
  AppPages({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  AppPagesState createState() => AppPagesState();
}

class AppPagesState extends State<AppPages> {
  Future<DayInfo> readings;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    readings = fetchReadings(dateStr);
  }

  // Control pages
  PageController _controller = PageController(
    initialPage: 0,
  );

  void chooseReadings() async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    _displayReadings();
  }

  void _displayReadings() {
    if (selectedDate != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      var newReadings = fetchReadings(dateStr);
      setState(() {
        readings = newReadings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        MainPage(this),
        ReadingsPage(this),
        SaintsPage(this),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToReadingsPage() {
    _controller.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goToSaintsPage() {
    _controller.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
