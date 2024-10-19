import 'package:flutter/material.dart';
import 'package:medico/WebScreens/add_medicines_web.dart';
import 'package:medico/WebScreens/home_web_screen.dart';
import 'package:medico/WebScreens/profile_web.dart';
import 'package:medico/utils/custom_text.dart';
import 'package:medico/utils/my_list_tile.dart';

class DeviderHome extends StatefulWidget {
  const DeviderHome({super.key});

  @override
  State<DeviderHome> createState() => _DeviderHomeState();
}

class _DeviderHomeState extends State<DeviderHome> {
  int _selectedIndex = 0; // Track which menu item is selected

  // List of screens/content to show when different menu items are selected
  final List<Widget> _screens = [
   const HomeWebScreen(),
    const AddMedicinesWeb(),
    const ProfileWeb(),
  ];

  // Method to handle ListTile taps and change the screen
  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Drawer on the left side
          Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero, // Remove default padding
              children: [
                 DrawerHeader(
                 
                  
                  decoration: const BoxDecoration(),
                  child:Container(
                    height: 50,
                    width: 60,
                    decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(
                      10
                    )),
                    child:  const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      CircleAvatar(
                        radius: 30,
                      ),
                      SizedBox(height: 5,),
                      MyTextt(text: "Amjad Ali",fontSize: 15,),
                       SizedBox(height: 5,),
                      MyTextt(text: "amjad@gmail.com",fontSize: 12,),
                     
                    ],),
                  )
                ),
                MyListTile(
                  title: "Home",
                  icon: Icons.home,
                  onTap: () {
                    _onMenuItemSelected(0); // Navigate to Home screen
                  },
                ),
                const SizedBox(height: 15),
                MyListTile(
                  title: "Add Medicines",
                  icon: Icons.add,
                  onTap: () {
                    _onMenuItemSelected(1); // Navigate to Add Medicines screen
                  },
                ),
                const SizedBox(height: 15),
                MyListTile(
                  title: "Profile",
                  icon: Icons.person,
                  onTap: () {
                    _onMenuItemSelected(2); // Navigate to Profile screen
                  },
                ),
                 Padding(
                        padding: const EdgeInsets.only(top: 200),
                        child: MyListTile(title: "LogOut", icon: Icons.logout, onTap: (){}),
                      )
              ],
            ),
          ),

          // Expanded widget to take the remaining space on the right for the screen content
          Expanded(
            child: _screens[_selectedIndex], // Display the selected screen
          ),
        ],
      ),
    );
  }
}
