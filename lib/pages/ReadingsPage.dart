import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../DayInfo.dart';
import 'PagesState.dart';

class ReadingsPage extends StatelessWidget {
  final AppPagesState state;

  ReadingsPage(this.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<DayInfo>(
                future: state.readings,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Html(
                      data: snapshot.data.formatReadings(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        "Error: please email to kliros@yorkorthodox.org");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
