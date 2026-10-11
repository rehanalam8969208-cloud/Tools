import 'package:flutter/material.dart';

class LudoGotiScreen extends StatefulWidget {
  const LudoGotiScreen({super.key});

  @override
  State<LudoGotiScreen> createState() => _LudoGotiScreenState();
}

class _LudoGotiScreenState extends State<LudoGotiScreen> {
  String selectedGoti = "RED";

  Widget _buildGotiView(String colorName, Color gotiColor) {
    bool isSelected = selectedGoti == colorName;
    return GestureDetector(
      onTap: () => setState(() => selectedGoti = colorName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isSelected ? 130 : 100,
        height: isSelected ? 130 : 100,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.redAccent : Colors.white24,
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white38, width: 2),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: gotiColor,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("LUDO GOTI"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "CHOOSE YOUR GOTI",
                style: TextStyle(color: Colors.white54, fontSize: 16, letterSpacing: 2),
              ),
              const SizedBox(height: 40),
              
              // Active Big Preview Goti
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.redAccent, width: 3),
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: selectedGoti == "RED"
                              ? Colors.redAccent
                              : (selectedGoti == "GREEN"
                                  ? Colors.greenAccent
                                  : (selectedGoti == "BLUE"
                                      ? Colors.blueAccent
                                      : Colors.yellowAccent)),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              Text(
                "$selectedGoti GOTI ACTIVE",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 50),
              
              // Selection Rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGotiView("RED", Colors.redAccent),
                  _buildGotiView("GREEN", Colors.greenAccent),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGotiView("BLUE", Colors.blueAccent),
                  _buildGotiView("YELLOW", Colors.yellowAccent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
