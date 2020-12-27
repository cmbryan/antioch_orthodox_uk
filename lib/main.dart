import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'Readings.dart';
import 'dbhelper.dart';

void main() async {
  // Need to do this before accessing the binary messenger during intialization
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Antioch Orthodox UK App',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyAppPages(title: 'Antioch Orthodox UK'),
    );
  }
}

class MyAppPages extends StatefulWidget {
  MyAppPages({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyAppPagesState createState() => _MyAppPagesState();
}

class _MyAppPagesState extends State<MyAppPages> {
  DbHelper dbHelper;
  Readings readings;
  DateTime selectedDate = DateTime.now();

  // Control pages
  PageController _controller = PageController(
    initialPage: 0,
  );

  _MyAppPagesState() {
    dbHelper = DbHelper();
    _displayReadings();
  }

  void chooseReadings() async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    _displayReadings();
  }

  void _displayReadings() async {
    if (selectedDate != null) {
      await dbHelper.init();
      var newReadings = await dbHelper.getEpistleReadings(selectedDate);
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
}

class ReadingsPage extends StatelessWidget {
  final _MyAppPagesState state;

  ReadingsPage(this.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Html(
              data: state.readings.formatReadings(),
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: state.chooseReadings,
        tooltip: 'Choose date',
        child: Icon(Icons.date_range),
      ),
    );
  }
}

class SaintsPage extends StatelessWidget {
  final _MyAppPagesState state;

  SaintsPage(this.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Html(
              data: state.readings.formatSaints(),
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: state.chooseReadings,
        tooltip: 'Choose date',
        child: Icon(Icons.date_range),
      ),
    );
  }
}
