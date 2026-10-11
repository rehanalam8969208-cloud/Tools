import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tools.dart'; // Saare tools yahan se aayenge

void main() {
  runApp(const MultiToolApp());
}

class MultiToolApp extends StatelessWidget {
  const MultiToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nothing Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // Nothing True Black
        textTheme: GoogleFonts.spaceMonoTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.spaceMono(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> tools = const [
    {"name": "QR GEN", "icon": Icons.qr_code_2, "page": QRGeneratorScreen()},
    {"name": "PASS GEN", "icon": Icons.password, "page": PasswordGenScreen()},
    {"name": "AGE CALC", "icon": Icons.cake, "page": AgeCalcScreen()},
    {"name": "BMI CALC", "icon": Icons.monitor_weight, "page": BMICalcScreen()},
    {"name": "DICE", "icon": Icons.casino, "page": DiceRollerScreen()},
    {"name": "DISCOUNT", "icon": Icons.percent, "page": DiscountCalcScreen()},
    {"name": "RANDOM #", "icon": Icons.shuffle, "page": RandomNumScreen()},
    {"name": "MATH", "icon": Icons.calculate, "page": SimpleCalcScreen()},
    {"name": "SCANNER", "icon": Icons.qr_code_scanner, "page": null}, // Next phase
    {"name": "TORCH", "icon": Icons.flashlight_on, "page": null}, // Next phase
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PRO.TOOLS"),
        leading: const Icon(Icons.apps, color: Colors.redAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: GridView.builder(
          itemCount: tools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Spaced out 2-column Nothing style
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            childAspectRatio: 1.0, // Perfect square widgets
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (tools[index]['page'] != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => tools[index]['page']));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text("${tools[index]['name']} requires hardware access (Next update)"),
                  ));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF121212), // Dark grey widget bg
                  borderRadius: BorderRadius.circular(30), // Large Nothing curves
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tools[index]['icon'], size: 45, color: Colors.white),
                    const SizedBox(height: 15),
                    Text(
                      tools[index]['name'], 
                      style: GoogleFonts.spaceMono(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 5),
                    Container(width: 20, height: 3, color: Colors.redAccent) // Nothing red accent
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
