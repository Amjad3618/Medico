import 'package:flutter/material.dart';
import 'package:medico/MobileScreen/add_madecines_mobile.dart';
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
    const HomeMobile(),
    const OrderReceivingPageMobile(),
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

      // Bottom Navigation Bar with Images instead of Icons
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the currently selected tab
        onTap: _onItemTapped, // Handle tap on a tab
        type: BottomNavigationBarType.fixed, // Keep the bar size fixed
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0 
                ? Image.asset('assets/house.png', height: 24) // Show selected image
                : Image.asset('assets/house.png', height: 24), // Show unselected image
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1 
                ? Image.asset('assets/delivery-man.png', height: 24) 
                : Image.asset('assets/delivery-man.png', height: 24),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2 
                ? Image.asset('assets/add-to-cart.png', height: 24) 
                : Image.asset('assets/add-to-cart.png', height: 24),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3 
                ? Image.asset('assets/user.png', height: 24) 
                : Image.asset('assets/user.png', height: 24),
            label: 'Profile',
          ),
        ],
        // Remove selected/unselected color to keep original image colors
        selectedItemColor: null,
        unselectedItemColor: null,
      ),
    );
  }
}
