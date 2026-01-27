import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ปฏิทินนัดหมาย",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text("จัดการการนัดพบแพทย์", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
      body: Column(children: [Text("this is body")]),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
