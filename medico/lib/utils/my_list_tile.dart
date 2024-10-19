import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  final String title;
  
  final IconData icon;
  final VoidCallback onTap;

  const MyListTile({
    Key? key,
    required this.title,
   
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  _MyListTileState createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool _isHovered = false; // To track hover state

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _isHovered ? Colors.blue[100] : Colors.transparent,
            borderRadius: BorderRadius.circular(10), // Add a rounded border if needed
          ),
          child: ListTile(
            leading: Icon(widget.icon, color: _isHovered ? Colors.blue : Colors.black),
            title: Text(
              widget.title,
              style: TextStyle(
                color: _isHovered ? Colors.blue : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
           
          ),
        ),
      ),
    );
  }
}
