import 'package:flutter/material.dart';
import 'screens/form_screen.dart';

void main() {
  runApp(const DecouverteApp());
}

class DecouverteApp extends StatelessWidget {
  const DecouverteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DéCOuverte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A2E8)),
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      home: const FormScreen(),
    );
  }
}
