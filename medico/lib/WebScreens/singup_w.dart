import 'package:flutter/material.dart';
import 'package:medico/utils/custom_text.dart';
import 'package:medico/utils/custome-button.dart';
import 'package:medico/utils/custome_form.dart';

class SingUpW extends StatefulWidget {
  const SingUpW({super.key});

  @override
  State<SingUpW> createState() => _SingUpWState();
}

class _SingUpWState extends State<SingUpW> {
  final _emailctrl = TextEditingController();
  final _password = TextEditingController();
    final _name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MyTextt(
              text: "Register New User  ",
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(
              height: 10,
            ),
            const MyTextt(
              text: "Enter Email and password to Register new account ",
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                children: [
                       CustomTextFormField(
                    hintText: "Name",
                    controller: _name,
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(

                    hintText: "Email",
                    controller: _emailctrl,
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    hintText: "password",
                    controller: _password,
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'password should be 6 character at least';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                 const  SizedBox(height: 
                  15,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const MyTextt(text: "Dom't have on account?"),
                      const SizedBox(width: 3,),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const MyTextt(text: "Login",color: Colors.blue,fontSize: 20,)),
                    ],
                  )
                ],
              ),
            ),
           MyElevatedButton(text: "SingUp", onPressed: (){})
          ],
        ),
      ),
    )));
  }
}
