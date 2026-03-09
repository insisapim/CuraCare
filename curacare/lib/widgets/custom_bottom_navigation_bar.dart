import 'package:curacare/pages/appointment_page.dart';
import 'package:curacare/pages/firstaid_page.dart';
import 'package:curacare/pages/homepage.dart';
import 'package:curacare/pages/profile_page.dart';
import 'package:curacare/pages/routine_page.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final pages = [
    HomePage(),
    RoutinePage(),
    AppointmentPage(),
    FirstaidPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าหลัก"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "กิจวัตร"),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "นัดหมาย"),
        BottomNavigationBarItem(
          icon: Icon(Icons.dangerous),
          label: "ปฐมพยาบาล",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "โปรไฟล์"),
      ],
      currentIndex: widget.currentIndex,
      onTap: (value) {
        if (value > pages.length) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (context) => pages[value]),
        );
      },
    );
  }
}
