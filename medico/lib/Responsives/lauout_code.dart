import 'package:flutter/material.dart';

class LayoutCode extends StatefulWidget {
  final Widget mobilescreen;
  final Widget websitescreen;

  const LayoutCode({
    super.key,
    required this.mobilescreen,
    required this.websitescreen,
  });

  @override
  State<LayoutCode> createState() => _LayoutCodeState();
}

class _LayoutCodeState extends State<LayoutCode> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define breakpoints for responsiveness
        if (constraints.maxWidth < 600) {
          // Mobile layout
          return widget.mobilescreen; // Use widget.mobilescreen to access it
        } else {
          // Web/Desktop layout
          return widget.websitescreen; // Use widget.websitescreen to access it
        }
      },
    );
  }
}
