import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'dart:async';

// Helper: Sab kuch screen ke Center me rakhne ke liye
Widget _buildToolScaffold(String title, Widget body) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(title: Text(title, style: const TextStyle(letterSpacing: 2)), backgroundColor: Colors.black, elevation: 0),
    body: Center( // 💥 YAHAN SAB KUCH BAA-KAYDA CENTER KIYA HAI 💥
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: body,
      ),
    ),
  );
}

// 1. QR GENERATOR
class QRGeneratorScreen extends StatefulWidget { const QRGeneratorScreen({super.key}); @override State<QRGeneratorScreen> createState() => _QRGeneratorScreenState(); }
class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  String qrData = "NOTHING";
  @override Widget build(BuildContext context) {
    return _buildToolScaffold("QR GEN", Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          onChanged: (val) => setState(() => qrData = val.isEmpty ? "NOTHING" : val),
          decoration: InputDecoration(hintText: "Type to generate...", hintStyle: const TextStyle(color: Colors.white38), filled: true, fillColor: const Color(0xFF121212), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white24)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.redAccent))),
        ),
        const SizedBox(height: 50),
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: QrImageView(data: qrData, size: 220)),
      ],
    ));
  }
}

// 2. PASSWORD GENERATOR (With Copy Button)
class PasswordGenScreen extends StatefulWidget { const PasswordGenScreen({super.key}); @override State<PasswordGenScreen> createState() => _PasswordGenScreenState(); }
class _PasswordGenScreenState extends State<PasswordGenScreen> {
  String pass = "Tap Generate";
  void _genPass() {
    const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*";
    setState(() => pass = List.generate(12, (index) => chars[Random().nextInt(chars.length)]).join());
  }
  @override Widget build(BuildContext context) {
    return _buildToolScaffold("PASS GEN", Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Text(pass, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent, fontSize: 30, fontWeight: FontWeight.bold))),
            // 💥 COPY BUTTON 💥
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.white, size: 30),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: pass));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password Copied!"), backgroundColor: Colors.redAccent));
              },
            )
          ],
        ),
        const SizedBox(height: 60),
        _buildNothingButton("GENERATE SECURE PASSWORD", _genPass),
      ],
    ));
  }
}

// 3. BMI CALCULATOR (Centered Inputs)
class BMICalcScreen extends StatefulWidget { const BMICalcScreen({super.key}); @override State<BMICalcScreen> createState() => _BMICalcScreenState(); }
class _BMICalcScreenState extends State<BMICalcScreen> {
  final wCtrl = TextEditingController(); final hCtrl = TextEditingController(); String res = "0.0";
  void _calc() {
    double? w = double.tryParse(wCtrl.text); double? h = double.tryParse(hCtrl.text);
    if (w != null && h != null) setState(() => res = (w / ((h/100)*(h/100))).toStringAsFixed(1));
  }
  @override Widget build(BuildContext context) {
    return _buildToolScaffold("BMI CALC", Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNothingInput(wCtrl, "Weight (KG)"),
        const SizedBox(height: 20),
        _buildNothingInput(hCtrl, "Height (CM)"),
        const SizedBox(height: 40),
        _buildNothingButton("CALCULATE", _calc),
        const SizedBox(height: 50),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(res, key: ValueKey(res), style: const TextStyle(color: Colors.redAccent, fontSize: 60, fontWeight: FontWeight.bold)),
        )
      ],
    ));
  }
}

// 4. LUDO DICE ROLLER (Asli Ludo wala Dice + Animation)
class DiceRollerScreen extends StatefulWidget { const DiceRollerScreen({super.key}); @override State<DiceRollerScreen> createState() => _DiceRollerScreenState(); }
class _DiceRollerScreenState extends State<DiceRollerScreen> {
  int dice = 1;
  void _roll() {
    setState(() => dice = Random().nextInt(6) + 1);
  }
  
  // Asli ludo ke dots bananeka logic
  Widget _buildDot() => Container(margin: const EdgeInsets.all(5), width: 25, height: 25, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle));

  Widget _getDiceFace() {
    List<Widget> dots = [];
    if (dice == 1) dots = [_buildDot()];
    else if (dice == 2) dots = [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildDot(), const SizedBox(), _buildDot()])];
    else if (dice == 3) dots = [Align(alignment: Alignment.topLeft, child: _buildDot()), Center(child: _buildDot()), Align(alignment: Alignment.bottomRight, child: _buildDot())];
    else if (dice == 4) dots = [Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildDot(), _buildDot()]), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildDot(), _buildDot()])];
    else if (dice == 5) dots = [Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildDot(), _buildDot()]), Center(child: _buildDot()), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildDot(), _buildDot()])];
    else if (dice == 6) dots = [Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildDot(), _buildDot(), _buildDot()]), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildDot(), _buildDot(), _buildDot()])];

    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: dots);
  }

  @override Widget build(BuildContext context) {
    return _buildToolScaffold("LUDO DICE", Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (w, a) => ScaleTransition(scale: a, child: w),
          child: Container(
            key: ValueKey(dice),
            width: 150, height: 150,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: _getDiceFace(), // 💥 Asli Dots 💥
          ),
        ),
        const SizedBox(height: 60),
        _buildNothingButton("ROLL DICE", _roll),
      ],
    ));
  }
}

// 5. DISCOUNT CALCULATOR
class DiscountCalcScreen extends StatefulWidget { const DiscountCalcScreen({super.key}); @override State<DiscountCalcScreen> createState() => _DiscountCalcScreenState(); }
class _DiscountCalcScreenState extends State<DiscountCalcScreen> {
  final pCtrl = TextEditingController(); final dCtrl = TextEditingController(); String res = "0.00";
  void _calc() {
    double? p = double.tryParse(pCtrl.text); double? d = double.tryParse(dCtrl.text);
    if (p != null && d != null) setState(() => res = (p - (p * d / 100)).toStringAsFixed(2));
  }
  @override Widget build(BuildContext context) {
    return _buildToolScaffold("DISCOUNT", Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNothingInput(pCtrl, "Original Price (₹)"),
        const SizedBox(height: 20),
        _buildNothingInput(dCtrl, "Discount %"),
        const SizedBox(height: 40),
        _buildNothingButton("CALCULATE", _calc),
        const SizedBox(height: 50),
        AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: Text("₹$res", key: ValueKey(res), style: const TextStyle(color: Colors.redAccent, fontSize: 50, fontWeight: FontWeight.bold)))
      ],
    ));
  }
}

// 6. RANDOM NUMBER (Centered & Animated)
class RandomNumScreen extends StatefulWidget { const RandomNumScreen({super.key}); @override State<RandomNumScreen> createState() => _RandomNumScreenState(); }
class _RandomNumScreenState extends State<RandomNumScreen> {
  int num = 0;
  @override Widget build(BuildContext context) {
    return _buildToolScaffold("RANDOM #", Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("1 to 100", style: TextStyle(color: Colors.white54, fontSize: 20, letterSpacing: 2)),
        const SizedBox(height: 30),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (w, a) => FadeTransition(opacity: a, child: ScaleTransition(scale: a, child: w)),
          child: Text("$num", key: ValueKey(num), style: const TextStyle(color: Colors.white, fontSize: 120, fontWeight: FontWeight.w900)),
        ),
        const SizedBox(height: 50),
        _buildNothingButton("GENERATE", () => setState(() => num = Random().nextInt(100) + 1))
      ],
    ));
  }
}

// 7. AGE CALCULATOR 
class AgeCalcScreen extends StatefulWidget { const AgeCalcScreen({super.key}); @override State<AgeCalcScreen> createState() => _AgeCalcScreenState(); }
class _AgeCalcScreenState extends State<AgeCalcScreen> {
  String res = "XX Yrs, XX Mos";
  void _pickDate() async {
    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        int years = DateTime.now().year - picked.year; int months = DateTime.now().month - picked.month; int days = DateTime.now().day - picked.day;
        if (months < 0 || (months == 0 && days < 0)) { years--; months += (months < 0 ? 12 : 11); }
        res = "$years YRS, $months MOS";
      });
    }
  }
  @override Widget build(BuildContext context) {
    return _buildToolScaffold("AGE CALC", Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: Text(res, key: ValueKey(res), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold))),
      const SizedBox(height: 60),
      _buildNothingButton("PICK DOB", _pickDate),
    ]));
  }
}

// 8. MATH CALCULATOR (Center aligned inputs)
class SimpleCalcScreen extends StatefulWidget { const SimpleCalcScreen({super.key}); @override State<SimpleCalcScreen> createState() => _SimpleCalcScreenState(); }
class _SimpleCalcScreenState extends State<SimpleCalcScreen> {
  final n1Ctrl = TextEditingController(); final n2Ctrl = TextEditingController(); String res = "0";
  void _calc(String op) {
    double? n1 = double.tryParse(n1Ctrl.text); double? n2 = double.tryParse(n2Ctrl.text);
    if (n1 != null && n2 != null) {
      setState(() {
        if (op == '+') res = "${n1 + n2}"; else if (op == '-') res = "${n1 - n2}"; else if (op == '*') res = "${n1 * n2}"; else if (op == '/') res = "${n1 / n2}";
      });
    }
  }
  @override Widget build(BuildContext context) {
    return _buildToolScaffold("MATH", Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildNothingInput(n1Ctrl, "First Number"),
      const SizedBox(height: 20),
      _buildNothingInput(n2Ctrl, "Second Number"),
      const SizedBox(height: 40),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _mathBtn('+', Colors.white, Colors.black), _mathBtn('-', Colors.white, Colors.black), _mathBtn('*', Colors.white, Colors.black), _mathBtn('/', Colors.redAccent, Colors.white),
      ]),
      const SizedBox(height: 50),
      AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: Text(res, key: ValueKey(res), style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)))
    ]));
  }
  Widget _mathBtn(String txt, Color bg, Color fg) => InkWell(onTap: () => _calc(txt), child: Container(width: 60, height: 60, decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Center(child: Text(txt, style: TextStyle(color: fg, fontSize: 30, fontWeight: FontWeight.bold)))));
}

// 9. STOPWATCH
class StopwatchScreen extends StatefulWidget { const StopwatchScreen({super.key}); @override State<StopwatchScreen> createState() => _StopwatchScreenState(); }
class _StopwatchScreenState extends State<StopwatchScreen> {
  Stopwatch watch = Stopwatch(); Timer? timer; String timeStr = "00:00:00";
  void updateTime(Timer t) { if (watch.isRunning) setState(() => timeStr = "${watch.elapsed.inHours.toString().padLeft(2, '0')}:${(watch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(watch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}"); }
  void startStop() { if (watch.isRunning) { watch.stop(); timer?.cancel(); } else { watch.start(); timer = Timer.periodic(const Duration(seconds: 1), updateTime); } setState(() {}); }
  void reset() { watch.reset(); timer?.cancel(); setState(() => timeStr = "00:00:00"); }
  @override Widget build(BuildContext context) {
    return _buildToolScaffold("STOPWATCH", Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(timeStr, style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold, letterSpacing: 4)),
      const SizedBox(height: 60),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildNothingButton(watch.isRunning ? "PAUSE" : "START", startStop, color: watch.isRunning ? Colors.redAccent : Colors.white),
        _buildNothingButton("RESET", reset, color: Colors.grey[800]!),
      ])
    ]));
  }
}

// 10. TIC-TAC-TOE
class TicTacToeScreen extends StatefulWidget { const TicTacToeScreen({super.key}); @override State<TicTacToeScreen> createState() => _TicTacToeScreenState(); }
class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, ""); bool isXTurn = true; String winner = "";
  void tap(int i) {
    if (board[i] == "" && winner == "") setState(() { board[i] = isXTurn ? "X" : "O"; isXTurn = !isXTurn; checkWinner(); });
  }
  void checkWinner() {
    List<List<int>> wins = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]];
    for (var w in wins) { if (board[w[0]] != "" && board[w[0]] == board[w[1]] && board[w[1]] == board[w[2]]) { winner = "${board[w[0]]} WINS!"; return; } }
    if (!board.contains("")) winner = "DRAW!";
  }
  void reset() => setState(() { board = List.filled(9, ""); isXTurn = true; winner = ""; });
  @override Widget build(BuildContext context) {
    return _buildToolScaffold("TIC-TAC-TOE", Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(winner == "" ? "TURN: ${isXTurn ? 'X' : 'O'}" : winner, style: TextStyle(color: winner == "" ? Colors.white : Colors.redAccent, fontSize: 30, fontWeight: FontWeight.bold)),
      const SizedBox(height: 40),
      SizedBox(height: 300, width: 300, child: GridView.builder(physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: 9, itemBuilder: (c, i) => InkWell(onTap: () => tap(i), child: Container(decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white24)), child: Center(child: AnimatedSwitcher(duration: const Duration(milliseconds: 200), transitionBuilder: (w, a) => ScaleTransition(scale: a, child: w), child: Text(board[i], key: ValueKey(board[i]), style: TextStyle(color: board[i] == "X" ? Colors.white : Colors.redAccent, fontSize: 50, fontWeight: FontWeight.bold)))))))),
      const SizedBox(height: 50),
      _buildNothingButton("RESET GAME", reset)
    ]));
  }
}

// --- GLOBAL STYLED WIDGETS ---
// Styling TextFields centrally
Widget _buildNothingInput(TextEditingController ctrl, String hint) {
  return TextField(
    controller: ctrl,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 16),
      filled: true,
      fillColor: const Color(0xFF121212),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white24)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
    ),
  );
}

// Styling Premium Buttons
Widget _buildNothingButton(String text, VoidCallback onTap, {Color color = Colors.white}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(30),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
      child: Text(text, style: TextStyle(color: color == Colors.white ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1)),
    ),
  );
}
// 11. ROCK PAPER SCISSORS
class RockPaperScissorsScreen extends StatefulWidget { const RockPaperScissorsScreen({super.key}); @override State<RockPaperScissorsScreen> createState() => _RockPaperScissorsScreenState(); }
class _RockPaperScissorsScreenState extends State<RockPaperScissorsScreen> {
  String uChoice = "";
  String bChoice = "";
  String res = "MAKE A MOVE";
  int uScore = 0;
  int bScore = 0;

  void play(String choice) {
    List<String> options = ["ROCK", "PAPER", "SCISSORS"];
    String bot = options[Random().nextInt(3)];
    String out = "";

    if (choice == bot) {
      out = "IT'S A TIE!";
    } else if ((choice == "ROCK" && bot == "SCISSORS") || (choice == "PAPER" && bot == "ROCK") || (choice == "SCISSORS" && bot == "PAPER")) {
      out = "YOU WIN!";
      uScore++;
    } else {
      out = "BOT WINS!";
      bScore++;
    }

    setState(() { uChoice = choice; bChoice = bot; res = out; });
  }

  void reset() => setState(() { uChoice = ""; bChoice = ""; res = "MAKE A MOVE"; uScore = 0; bScore = 0; });

  @override Widget build(BuildContext context) {
    return _buildToolScaffold("R-P-S GAME", Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(children: [const Text("YOU", style: TextStyle(color: Colors.white54, fontSize: 18)), Text("$uScore", style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold))]),
        const Text("vs", style: TextStyle(color: Colors.redAccent, fontSize: 24, fontStyle: FontStyle.italic)),
        Column(children: [const Text("BOT", style: TextStyle(color: Colors.white54, fontSize: 18)), Text("$bScore", style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold))]),
      ]),
      const SizedBox(height: 50),
      AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: Text(res, key: ValueKey(res), textAlign: TextAlign.center, style: TextStyle(color: res == "YOU WIN!" ? Colors.greenAccent : (res == "BOT WINS!" ? Colors.redAccent : Colors.white), fontSize: 35, fontWeight: FontWeight.w900))),
      const SizedBox(height: 30),
      Text(uChoice != "" ? "You: $uChoice  |  Bot: $bChoice" : "", style: const TextStyle(color: Colors.white70, fontSize: 16)),
      const SizedBox(height: 60),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildGameBtn(Icons.sports_martial_arts, "ROCK"),
        _buildGameBtn(Icons.back_hand, "PAPER"),
        _buildGameBtn(Icons.content_cut, "SCISSORS"),
      ]),
      const SizedBox(height: 50),
      if (uScore > 0 || bScore > 0) _buildNothingButton("RESET MATCH", reset, color: Colors.grey[800]!)
    ]));
  }

  Widget _buildGameBtn(IconData icon, String choice) {
    return InkWell(
      onTap: () => play(choice),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white24)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 5),
          Text(choice, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }
}
