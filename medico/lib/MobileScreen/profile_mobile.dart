import 'package:flutter/material.dart';

class ProfileMobile extends StatefulWidget {
  const ProfileMobile({super.key});

  @override
  State<ProfileMobile> createState() => _ProfileMobileState();
}

class _ProfileMobileState extends State<ProfileMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("profile mobile"),),);
  }
}