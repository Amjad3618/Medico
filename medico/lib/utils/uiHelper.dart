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
    return  StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    // Add debug prints
    print('Connection State: ${snapshot.connectionState}');
    print('Has Data: ${snapshot.hasData}');
    print('Current User: ${FirebaseAuth.instance.currentUser?.uid}');
    
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasData && snapshot.data != null) {
      final screenWidth = MediaQuery.of(context).size.width;
      return screenWidth > 800 
          ? const DividerHome()
          : const BottomNavMobile();
    } else {
      return const LayoutCode(
        mobilescreen: LoginM(),
        websitescreen: LoginW(),
      );
    }
  },
);
}
}