import 'package:curacare/pages/health_page.dart';
import 'package:curacare/pages/home_page.dart';
import 'package:curacare/pages/med_page.dart';
import 'package:curacare/pages/profile_page.dart';
import 'package:curacare/pages/search_page.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    MedPage(),
    HealthPage(),
    ProfilePage(),
  ];

  Widget _navItemIcon(IconData icon) {
    return Container(padding: EdgeInsets.all(8.0), child: Icon(icon));
  }

  Widget _activeNavItemIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(icon),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedIconTheme: IconThemeData(applyTextScaling: false),
      items: [
        BottomNavigationBarItem(
          icon: _navItemIcon(Icons.home_outlined),
          label: 'Home',
          activeIcon: _activeNavItemIcon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          icon: _navItemIcon(Icons.search_outlined),
          label: 'Search',
          activeIcon: _activeNavItemIcon(Icons.search_outlined),
        ),
        BottomNavigationBarItem(
          icon: _navItemIcon(Icons.medication_outlined),
          label: 'Med',
          activeIcon: _activeNavItemIcon(Icons.medication_outlined),
        ),
        BottomNavigationBarItem(
          icon: _navItemIcon(Icons.favorite_outline),
          label: 'Health',
          activeIcon: _activeNavItemIcon(Icons.favorite_outline),
        ),
        BottomNavigationBarItem(
          icon: _navItemIcon(Icons.person_outline),
          label: 'Profile',
          activeIcon: _activeNavItemIcon(Icons.person_outline),
        ),
      ],
      currentIndex: _currentPage,
      onTap: (value) => setState(() {
        _currentPage = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentPage, children: _pages),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
