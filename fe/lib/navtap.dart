import 'package:flutter/material.dart';
import 'Home_Page.dart';
import 'Report.dart';
import 'Profile_Page.dart';
import 'AboutPage.dart';

class NavTap extends StatefulWidget {
  @override
  _NavTapState createState() => _NavTapState();
}

class _NavTapState extends State<NavTap> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(),
          ProfilePage(),
          ReportsList(),
          AboutPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.blue),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report, color: Colors.blue),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.blue),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 9, 9, 9),
        onTap: _onItemTapped,
      ),
    );
  }
}
