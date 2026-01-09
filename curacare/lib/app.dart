import 'package:curacare/screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 125, 255, 125),
          surface: Color.fromARGB(255, 224, 254, 236),
        ),
      ),
      home: MyWidget(),
    );
  }
}
