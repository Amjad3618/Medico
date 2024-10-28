import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medico/utils/custom_text.dart';
import 'package:medico/utils/custome-button.dart';
import 'package:medico/utils/custome_form.dart';
import '../data/firebase_auth_services.dart';
import 'bottom_nav_mobile.dart'; // Make sure this path is correct

class SignUpM extends StatefulWidget {
  const SignUpM({super.key});

  @override
  State<SignUpM> createState() => _SignUpMState();
}

class _SignUpMState extends State<SignUpM> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  bool _isLoading = false;
  XFile? _selectedImage; // Store the selected image

  final ImagePicker _picker = ImagePicker();

  // Method to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  // Sign up method
  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      await _authService.completeSignUpProcess(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        name: _nameCtrl.text.trim(),
        profileImage: _selectedImage,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up successful!')),
      );

      // Navigate to BottomNavMobile page after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavMobile()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: screenSize.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MyTextt(
                  text: "Welcome Back",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const MyTextt(
                  text: "Sign up with Email and Password",
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    backgroundImage:
                        _selectedImage != null ? FileImage(File(_selectedImage!.path)) : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.person_add_alt, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: "Enter user name",
                        controller: _nameCtrl,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: "Email",
                        controller: _emailCtrl,
                        prefixIcon: const Icon(Icons.email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: "Password",
                        controller: _passwordCtrl,
                        prefixIcon: const Icon(Icons.lock),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 6) {
                            return 'Password should be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const MyTextt(text: "Already have an account?"),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const MyTextt(
                              text: "Log In",
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                MyElevatedButton(
                  text: _isLoading ? "Signing Up..." : "Sign Up",
                  onPressed: (){_isLoading ? null : _signUp();}
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
