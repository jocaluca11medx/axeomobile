import 'package:flutter/material.dart';
import 'screens/trilha_screen.dart';

void main() {
  runApp(const AxeoApp());
}

class AxeoApp extends StatelessWidget {
  const AxeoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Axeo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.red,
      ),
      home: const TrilhaScreen(),
    );
  }
}