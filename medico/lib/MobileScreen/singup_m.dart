import 'package:flutter/material.dart';
import 'package:medico/utils/custom_text.dart';
import 'package:medico/utils/custome-button.dart';
import 'package:medico/utils/custome_form.dart';

class SingUpM extends StatefulWidget {
  const SingUpM({super.key});

  @override
  State<SingUpM> createState() => _SingUpMState();
}

class _SingUpMState extends State<SingUpM> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();final _namecrtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          height: screenSize.height * 10, // 80% of screen height
          width: screenSize.width * 0.9, // 90% of screen width
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20), // Use uniform padding
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
              const SizedBox(height: 10,),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange,
                child: Icon(Icons.person_add_alt),
              ),
              const SizedBox(height: 15),
              // Using a single container to handle padding and spacing
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10), // Padding for vertical spacing
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: "Enter user name",
                      controller: _namecrtl,
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
                        const MyTextt(text: "already have an account?"),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
            Navigator.pop(context);
                          },
                          child: const MyTextt(
                            text: "'LogIn",
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
                text: "SingUp",
                onPressed: () {
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
