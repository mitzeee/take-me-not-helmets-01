import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          canvasColor: Color(0xFFF5F6FF),
          fontFamily: 'Comfortaa',
        ),
      home: WelcomeScreen(),
    );
  }
}
