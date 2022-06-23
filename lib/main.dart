import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:web_qr_system/screens/login.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Host Panel',
      theme: ThemeData(

        primarySwatch: Colors.red,
      ),
      home: LoginScreen(),
    );
  }
}
