import 'package:flutter/material.dart';

import 'screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Noti-fy',
      theme: ThemeData(
        textTheme: TextTheme(
          caption: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
          title: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
      ),
      home: NoteList(),
    );
  }
}
