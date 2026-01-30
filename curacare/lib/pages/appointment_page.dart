import 'package:curacare/widgets/appointment_card.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              onDateChanged: (date) {
                print(date);
              },
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                "นัดหมายที่กำลังจะถึง",
                style: TextStyle(fontSize: 20),
              ),
            ),
            AppointmentCard(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
