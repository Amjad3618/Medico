import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medico/utils/uiHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Remove FirebaseOptions if google-services.json is set up correctly
  await Firebase.initializeApp();
  
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
      home: const UIHelper(),
    );
  }
}
