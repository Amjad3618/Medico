import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medico/WebScreens/add_medicines_web.dart';
import 'package:medico/WebScreens/home_web_screen.dart';
import 'package:medico/WebScreens/login_w.dart';
import 'package:medico/WebScreens/my_medicines.dart';
import 'package:medico/WebScreens/order_web.dart';
import 'package:medico/WebScreens/profile_web.dart';
import 'package:medico/utils/custom_text.dart';
import 'package:medico/utils/my_list_tile.dart';

class DeviderHome extends StatefulWidget {
  const DeviderHome({super.key});

  @override
  State<DeviderHome> createState() => _DeviderHomeState();
}

class _DeviderHomeState extends State<DeviderHome> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeWeb(),
    const AddMedicineWeb(),
     const ProfileScreenweb(),
     const OrderRecevingPageWeb(),
     const MyMedicinesPage()
  ];

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Row(
        children: [
          Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: const BoxDecoration(),
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading user data'));
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Center(child: Text('User not found'));
                        }

                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final imageUrl = userData['profileImageUrl'] ?? '';
                        final userName = userData['name'] ?? 'User';
                        final userEmail = userData['email'] ?? 'Email';

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : null,
                              child: imageUrl.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            const SizedBox(height: 5),
                            MyTextt(
                              text: userName,
                              fontSize: 15,
                            ),
                            const SizedBox(height: 5),
                            MyTextt(
                              text: userEmail,
                              fontSize: 12,
                            ),
                          ],
                        );
                      },
                    )),
                MyListTile(
                  title: "Home",
                  imageIcon: "assets/house.png",
                  onTap: () {
                    _onMenuItemSelected(0);
                  },
                ),
                const SizedBox(height: 15),
                MyListTile(
                  title: "Add Medicines",
                  imageIcon: "assets/add-to-cart.png",
                  onTap: () {
                    _onMenuItemSelected(1);
                  },
                ),
                const SizedBox(height: 15),
                MyListTile(
                  title: "Profile",
                  imageIcon: "assets/user.png",
                  onTap: () {
                    _onMenuItemSelected(2);
                  },
                ),
                const SizedBox(height: 15),
                MyListTile(
                  title: "Orders",
                  imageIcon: "assets/delivery-man.png",
                  onTap: () {
                    _onMenuItemSelected(3);
                  },
                ),
                const SizedBox(height: 15),
                MyListTile(
                  title: "My Products ",
                  imageIcon: "assets/bundling.png",
                  onTap: () {
                    _onMenuItemSelected(4);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: MyListTile(
                    title: "LogOut",
                    imageIcon: "assets/check-out.png",
                    onTap: () {
                      final auth = FirebaseAuth.instance;
                      auth.signOut();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => const LoginW()));
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
