import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tools.dart'; 

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
        scaffoldBackgroundColor: Colors.black, // True Black
        textTheme: GoogleFonts.spaceMonoTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.spaceMono(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 2),
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
    {"name": "STOPWATCH", "icon": Icons.timer, "page": StopwatchScreen()},
    {"name": "TIC-TAC-TOE", "icon": Icons.grid_3x3, "page": TicTacToeScreen()},
    {"name": "R-P-S", "icon": Icons.sports_kabaddi, "page": RockPaperScissorsScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PRO.TOOLS"),
        leading: const Icon(Icons.apps_outage, color: Colors.redAccent, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: tools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.95, // Tedha look ke liye box proportion
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => tools[index]['page'])),
              splashColor: Colors.redAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A), // Deep dark grey
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    topRight: Radius.circular(5), // Asymmetric Nothing Look
                    bottomLeft: Radius.circular(5),
                  ),
                  border: Border.all(color: Colors.white24, width: 1.5),
                ),
                child: Stack(
                  children: [
                    // Red Accent Dot
                    Positioned(
                      bottom: 15, right: 15,
                      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Tedha Icon (Tilted)
                          Transform.rotate(
                            angle: -0.15, // Icon ko thoda tedha kiya
                            child: Icon(tools[index]['icon'], size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            tools[index]['name'], 
                            style: GoogleFonts.spaceMono(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)
                          ),
                        ],
                      ),
                    ),
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
