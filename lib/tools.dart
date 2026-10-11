import 'package:flutter/material.dart';
import 'dart:math';

class LudoGotiScreen extends StatefulWidget {
  const LudoGotiScreen({super.key});

  @override
  State<LudoGotiScreen> createState() => _LudoGotiScreenState();
}

class _LudoGotiScreenState extends State<LudoGotiScreen> {
  int p1Position = 0; // Player 1 (Red) position (0 to 20)
  int p2Position = 0; // Player 2 (Green) position (0 to 20)
  bool isP1Turn = true;
  int diceVal = 1;
  String gameStatus = "PLAYER 1'S TURN (RED)";
  bool isRolled = false;

  void rollDice() {
    if (gameStatus.contains("WINS")) return;

    setState(() {
      diceVal = Random().nextInt(6) + 1;
      isRolled = true;
    });
  }

  void movePlayer() {
    if (!isRolled || gameStatus.contains("WINS")) return;

    setState(() {
      if (isP1Turn) {
        p1Position += diceVal;
        if (p1Position >= 20) {
          p1Position = 20;
          gameStatus = "PLAYER 1 (RED) WINS! 🎉";
        } else {
          isP1Turn = false;
          gameStatus = "PLAYER 2'S TURN (GREEN)";
        }
      } else {
        p2Position += diceVal;
        if (p2Position >= 20) {
          p2Position = 20;
          gameStatus = "PLAYER 2 (GREEN) WINS! 🎉";
        } else {
          isP1Turn = true;
          gameStatus = "PLAYER 1'S TURN (RED)";
        }
      }
      isRolled = false;
    });
  }

  void resetGame() {
    setState(() {
      p1Position = 0;
      p2Position = 0;
      isP1Turn = true;
      diceVal = 1;
      gameStatus = "PLAYER 1'S TURN (RED)";
      isRolled = false;
    });
  }

  Widget _buildGoti(Color color) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: Center(
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            ),
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
        title: const Text("LUDO 2-PLAYER", style: TextStyle(letterSpacing: 2)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status Text
            Text(
              gameStatus,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: gameStatus.contains("WINS") ? Colors.redAccent : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 30),

            // Ludo Track (20 Steps Board Simulation)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: Column(
                children: [
                  // Player 1 Track
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("RED", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      Text("Step: $p1Position/20", style: const TextStyle(color: Colors.white54)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Positioned(
                          left: (p1Position / 20) * (MediaQuery.of(context).size.width - 110),
                          child: _buildGoti(Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Player 2 Track
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("GREEN", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                      Text("Step: $p2Position/20", style: const TextStyle(color: Colors.white54)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Positioned(
                          left: (p2Position / 20) * (MediaQuery.of(context).size.width - 110),
                          child: _buildGoti(Colors.greenAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Dice Display & Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "$diceVal",
                      style: const TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: rollDice,
                      child: const Text("ROLL DICE", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: movePlayer,
                      child: const Text("MOVE GOTI", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),
            TextButton(
              onPressed: resetGame,
              child: const Text("RESET GAME", style: TextStyle(color: Colors.white54, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }
}
