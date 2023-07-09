import 'package:todo/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF9900),
            primary: const Color(0xFFFF9900),
            background: const Color(0xFFEDEDED),
            surface: Colors.white,
          ),
          textTheme: TextTheme(
            headlineSmall: GoogleFonts.montserrat(
              fontSize: 24,
              height: 32 / 24,
              fontWeight: FontWeight.bold,
            ),
            displayLarge: GoogleFonts.montserrat(
              fontSize: 18,
              height: 20 / 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF9900),

            ),
          ),
        ),
        home: const HomePage()
    );
  }
}