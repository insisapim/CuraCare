import 'package:curacare/pages/homepage.dart';
import 'package:curacare/pages/search_page.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<StatefulWidget> pages = [HomePage(), SearchPage()];
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าหลัก"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "ค้นหา"),
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
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (context) => pages[value]));
      },
    );
  }
}
