import 'package:flutter/material.dart';
import 'qr_generator.dart';

void main() {
  runApp(const MultiToolApp());
}

class MultiToolApp extends StatelessWidget {
  const MultiToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pro Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Premium Dark Slate
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Tools list array
  final List<Map<String, dynamic>> tools = const [
    {"name": "QR Generator", "icon": Icons.qr_code_2, "color": Colors.blueAccent},
    {"name": "QR Scanner", "icon": Icons.qr_code_scanner, "color": Colors.greenAccent},
    {"name": "Password Gen", "icon": Icons.password, "color": Colors.redAccent},
    {"name": "Age Calculator", "icon": Icons.cake, "color": Colors.orangeAccent},
    {"name": "BMI Calculator", "icon": Icons.monitor_weight, "color": Colors.purpleAccent},
    {"name": "Unit Converter", "icon": Icons.swap_horiz, "color": Colors.tealAccent},
    {"name": "Flashlight", "icon": Icons.flashlight_on, "color": Colors.yellowAccent},
    {"name": "Dice Roller", "icon": Icons.casino, "color": Colors.pinkAccent},
    {"name": "Text to Speech", "icon": Icons.record_voice_over, "color": Colors.cyanAccent},
    {"name": "Stopwatch", "icon": Icons.timer, "color": Colors.lightBlueAccent},
    {"name": "Discount Calc", "icon": Icons.percent, "color": Colors.deepOrangeAccent},
    {"name": "Quick Notes", "icon": Icons.note_alt, "color": Colors.amberAccent},
    {"name": "Calculator", "icon": Icons.calculate, "color": Colors.indigoAccent},
    {"name": "Random Num", "icon": Icons.shuffle, "color": Colors.lightGreenAccent},
    {"name": "Tic-Tac-Toe", "icon": Icons.grid_3x3, "color": Colors.deepPurpleAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PRO TOOLS")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: tools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Ek line mein 3 box
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  // Pehla button QR Generator ka hai
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QRGeneratorScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${tools[index]['name']} is coming next!")));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: tools[index]['color'].withOpacity(0.3), width: 1.5),
                  boxShadow: [BoxShadow(color: tools[index]['color'].withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tools[index]['icon'], size: 40, color: tools[index]['color']),
                    const SizedBox(height: 10),
                    Text(
                      tools[index]['name'], 
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)
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
