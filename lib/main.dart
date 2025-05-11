import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_project1/pause/pause_page.dart';
import 'package:provider/provider.dart';
import 'blocs/main_bloc.dart';

void main() {
  final mainBloc = MainBloc();
  runApp(
    Provider<MainBloc>.value(
      value: mainBloc,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'MarckScript-Regular', // Указываем имя из pubspec.yaml
      ),
      home: PausePage(),
    );
  }
}

