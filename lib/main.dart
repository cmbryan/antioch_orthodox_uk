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
      home: MyHomePage(title: 'Antioch Orthodox UK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbHelper dbHelper;
  Readings readings;
  DateTime selectedDate = DateTime.now();

  _MyHomePageState() {
    this.dbHelper = DbHelper();
    _displayReadings();
  }

  void _chooseReadings() async {
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Html(
              data: readings.format(),
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _chooseReadings,
        tooltip: 'Choose data',
        child: Icon(Icons.date_range),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
