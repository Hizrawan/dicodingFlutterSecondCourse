import 'package:flutter/material.dart';
import 'restaurant/restaurantLists.dart';
import 'profile.dart';

class DashboardScreen extends StatefulWidget {
  final String email;

  const DashboardScreen({super.key, required this.email});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<String> _titles = ["Home", "Courses", "Profile"];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      RestaurantLists(),
      ProfilePage(email: widget.email),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor:const Color.fromARGB(255, 231, 34, 34),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 68, 1, 1),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
