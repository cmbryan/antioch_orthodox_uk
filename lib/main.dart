import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'Reading.dart';
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
  Reading readings;
  DateTime selectedDate = DateTime.now();
  var readingText = 'TODO';

  void _chooseReading() async {
    if (this.dbHelper == null) {
      // Initialize the readings database object
      this.dbHelper = DbHelper();
      await dbHelper.init();
    }

    selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      try {
        this.readings = await dbHelper.getEpistleReadings(selectedDate);
        setState(() {
          this.readingText = this.readings.text;
        });
      } catch (err) {
        print('Error getting Epistle reading: $err');
        this.readings = null;
        setState(() {
          this.readingText = this.readings.text;
        });
      }
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
            RichText(text: TextSpan(text: 'TESTING')),
            Html(
              data: this.readingText,
            )
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _chooseReading,
        tooltip: 'Choose data',
        child: Icon(Icons.date_range),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
