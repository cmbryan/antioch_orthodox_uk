import 'package:antioch_orthodox_uk/pages/PagesState.dart';
import 'package:flutter/material.dart';

void main() async {
  // Need to do this before accessing the binary messenger during initialization
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
      home: AppPages(title: 'Antioch Orthodox UK'),
    );
  }
}
