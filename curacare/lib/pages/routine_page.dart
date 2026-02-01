import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('กิจวัตร'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Text("this is body"),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}