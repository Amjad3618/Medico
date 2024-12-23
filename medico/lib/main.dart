import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medico/utils/uiHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: "AIzaSyB9lM1XebxHtrcZQYvZRHfF1aSFsCj0ISk",
  //       authDomain: "medico-533fd.firebaseapp.com",
  //       databaseURL: "https://medico-533fd-default-rtdb.firebaseio.com",
  //       projectId: "medico-533fd",
  //       storageBucket: "medico-533fd.appspot.com",
  //       messagingSenderId: "479462515526",
  //       appId: "1:479462515526:web:530e58739f8f92d5c37b47"
  //     ),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }
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