import 'package:flutter/material.dart';

class SerachMobile extends StatefulWidget {
  const SerachMobile({super.key});

  @override
  State<SerachMobile> createState() => _SerachMobileState();
}

class _SerachMobileState extends State<SerachMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("search mobile"),),);
  }
}