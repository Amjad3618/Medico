import 'package:flutter/material.dart';
import 'package:medico/MobileScreen/add_p_mobile.dart';
import 'package:medico/MobileScreen/home_moile.dart';
import 'package:medico/MobileScreen/profile_mobile.dart';
import 'package:medico/MobileScreen/orders_mobile.dart';

class BottomNavMobile extends StatefulWidget {
  const BottomNavMobile({super.key});

  @override
  State<BottomNavMobile> createState() => _BottomNavMobileState();
}

class _BottomNavMobileState extends State<BottomNavMobile> {
  int _selectedIndex = 0; // Track the selected tab index

  // List of widgets corresponding to each tab
  final List<Widget> _screens = [

    const HomeMoile(),
    const OrdersMobile(),
    const AddMedicineMobile(),
    const ProfileMobile(),
    
  ];

  // Method to handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _screens[_selectedIndex], // Display the selected screen

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the currently selected tab
        onTap: _onItemTapped, // Handle tap on a tab
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue, // Color of selected tab
        unselectedItemColor: Colors.grey, // Color of unselected tabs
      ),
    );
  }
}
