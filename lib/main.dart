import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_sqflite/view/notes_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark),
      ),
      home: const NotesView(),
    );
  }
}
