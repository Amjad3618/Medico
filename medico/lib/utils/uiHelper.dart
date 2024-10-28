import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medico/MobileScreen/login_m.dart';
import 'package:medico/MobileScreen/bottom_nav_mobile.dart';

import 'package:medico/WebScreens/devider_home.dart';
import 'package:medico/WebScreens/login_w.dart';

import '../Responsives/lauout_code.dart';

class UIHelper extends StatelessWidget {
  const UIHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the user is logged in or not
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          // Check screen size and return appropriate home screen
          final screenWidth = MediaQuery.of(context).size.width;
          return screenWidth > 800 
              ? const DeviderHome()  // Web view
              : const BottomNavMobile();  // Mobile view
        } else {
          // If user is null, show the login screen depending on the platform
          return const LayoutCode(
            mobilescreen: LoginM(),
            websitescreen: LoginW(),
          );
        }
      },
    );
  }
}
