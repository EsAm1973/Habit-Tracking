import 'package:flutter/material.dart';
import 'package:habit_tracking/screens/home_page.dart';
import 'package:habit_tracking/screens/profile_screen.dart';
import 'package:habit_tracking/screens/tracking_screen.dart';

class ButtonNavBar extends StatefulWidget {
  const ButtonNavBar({super.key});

  @override
  State<ButtonNavBar> createState() => _ButtonNavBarState();
}

class _ButtonNavBarState extends State<ButtonNavBar> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    const HomePage(),
    const TrackingScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), // انحناء من الأعلى يسار
            topRight: Radius.circular(20), // انحناء من الأعلى يمين
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white, // لون الخلفية
            selectedItemColor:
                const Color.fromARGB(255, 119, 52, 196), // لون العنصر المحدد
            unselectedItemColor: const Color(0xFF9E9E9E), // لون العنصر غير المحدد
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Tracking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
