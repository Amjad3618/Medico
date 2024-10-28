import 'package:flutter/material.dart';
import 'package:medico/MobileScreen/singup_m.dart';
import 'package:medico/utils/custom_text.dart';
import 'package:medico/utils/custome-button.dart';
import 'package:medico/utils/custome_form.dart';

import 'bottom_nav_mobile.dart';

class LoginM extends StatefulWidget {
  const LoginM({super.key});

  @override
  State<LoginM> createState() => _LoginMState();
}

class _LoginMState extends State<LoginM> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          height: screenSize.height *10, // 80% of screen height
          width: screenSize.width * 0.9, // 90% of screen width
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20), // Use uniform padding
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, // Align children to stretch
              children: [
                const MyTextt(
                  text: "Welcome Back",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center, // Center text
                ),
                const SizedBox(height: 10),
                const MyTextt(
                  text: "Login with Email and Password",
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center, // Center text
                ),
                const SizedBox(height: 15),
                // Using a single container to handle padding and spacing
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10), // Padding for vertical spacing
                  child: Column(
                    children: [
                      
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
                          const MyTextt(text: "Don't have an account?"),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignUpM()),
                              );
                            },
                            child: const MyTextt(
                              text: "Sign Up",
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Space between the form and button
                MyElevatedButton(
                  text: "Log In",
                  onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_)=>const BottomNavMobile()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
