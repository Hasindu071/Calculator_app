//##################################### IM/2021/062 Hasindu Thirasara ############################################

import 'package:calculatormy/Calculator_Screen.dart'; // Import the CalculatorScreen class
import 'package:flutter/material.dart'; // Import the material library
import 'package:flutter/services.dart'; // Import the services library


void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the Flutter binding is initialized
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown]);// Set the preferred orientation to portrait
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Create a const constructor

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.dark(), // Set the theme to dark
      home: const CalculatorScreen(),
    );
  }  
}