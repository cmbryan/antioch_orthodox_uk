import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../DayInfo.dart';
import 'PagesState.dart';

class MainPage extends StatelessWidget {
  final AppPagesState state;
  final format = DateFormat.yMMMMd('en_US');

  MainPage(this.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: FutureBuilder<DayInfo>(
          future: state.readings,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Text(
                    format.format(state.selectedDate),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: state.goToReadingsPage,
                    child: Html(
                      data: '<i>Readings:</i><br/>' + snapshot.data.formatTitles(),
                    ),
                  ),
                  GestureDetector(
                    onTap: state.goToSaintsPage,
                    child: Html(
                      data: '<i>Commemorations:</i><br/>' + snapshot.data.formatSaints(),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("Error: please email to kliros@yorkorthodox.org");
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: state.chooseReadings,
        tooltip: 'Choose date',
        child: Icon(Icons.date_range),
      ),
    );
  }
}