import 'package:flutter/material.dart';
import 'package:medico/MobileScreen/add_p_mobile.dart';
import 'package:medico/MobileScreen/bottom_nav_mobile.dart';
import 'package:medico/MobileScreen/login_m.dart';
import 'package:medico/Responsives/lauout_code.dart';
import 'package:medico/WebScreens/devider_home.dart';
import 'package:medico/WebScreens/login_w.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Medico',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[100],
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const BottomNavMobile());
        home: AddPMobile());
        // home: const LayoutCode(
        //     mobilescreen: LoginM(), websitescreen:  LoginW()));
 }
}