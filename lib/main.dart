import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tools.dart'; 

void main() {
  runApp(const LudoGotiApp());
}

class LudoGotiApp extends StatelessWidget {
  const LudoGotiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo Goti Nothing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // True Black
        textTheme: GoogleFonts.spaceMonoTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.spaceMono(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      home: const LudoGotiScreen(),
    );
  }
}
