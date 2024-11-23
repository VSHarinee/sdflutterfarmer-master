
import 'package:farm2fork/screens/auth/user_type_selection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm App',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // used Default for most text
          bodyMedium: TextStyle(color: Colors.black), // used Secondary text

          // Large headings
        ),

      ),
      home: UserTypeSelection(),

    );
  }
}
