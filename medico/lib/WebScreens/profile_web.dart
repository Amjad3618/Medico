import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;

class ProfileWeb extends StatefulWidget {
  const ProfileWeb({super.key});

  @override
  State<ProfileWeb> createState() => _ProfileWebState();
}

class _ProfileWebState extends State<ProfileWeb> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;
  html.File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          width: screenSize.width > 800 ? 600 : screenSize.width * 0.85, // Adjusted for web
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image with editing functionality
                  GestureDetector(
                    onTap: _isEditing ? _pickImage : null,
                    child: CircleAvatar(
                      radius: 60, // Increased size for web
                      backgroundImage: _profileImage != null
                          ? Image.network(html.Url.createObjectUrl(_profileImage!))
                              .image
                          : const AssetImage("assets/default_profile.png"),
                      child: _isEditing
                          ? const Icon(Icons.camera_alt, color: Colors.white, size: 30)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30), // Increased padding for web

                  // Name TextField
                  TextField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email TextField
                  TextField(
                    controller: _emailController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        child: Text(_isEditing ? 'Cancel' : 'Edit'),
                      ),
                      ElevatedButton(
                        onPressed: _isEditing ? _submitProfile : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isEditing ? Colors.blue : Colors.grey,
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = html.File([ image.readAsBytes()], image.name);
      });
    }
  }

  void _submitProfile() {
    final name = _nameController.text;
    final email = _emailController.text;

    if (name.isNotEmpty && email.isNotEmpty) {
      print('Profile Submitted: $name, $email');
      setState(() {
        _isEditing = false;
      });
    } else {
      print('Please fill in all fields.');
    }
  }
}
