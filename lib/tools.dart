import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';

// 1. QR GENERATOR
class QRGeneratorScreen extends StatefulWidget { const QRGeneratorScreen({super.key}); @override State<QRGeneratorScreen> createState() => _QRGeneratorScreenState(); }
class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  String qrData = "NOTHING";
  @override
  Widget build(BuildContext context) {
    return _buildToolScaffold("QR GEN", Column(
      children: [
        TextField(
          style: const TextStyle(color: Colors.white),
          onChanged: (val) => setState(() => qrData = val.isEmpty ? "NOTHING" : val),
          decoration: InputDecoration(hintText: "Enter Text...", hintStyle: const TextStyle(color: Colors.white54), filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        ),
        const SizedBox(height: 40),
        Container(padding: const EdgeInsets.all(15), color: Colors.white, child: QrImageView(data: qrData, size: 200)),
      ],
    ));
  }
}

// 2. PASSWORD GENERATOR
class PasswordGenScreen extends StatefulWidget { const PasswordGenScreen({super.key}); @override State<PasswordGenScreen> createState() => _PasswordGenScreenState(); }
class _PasswordGenScreenState extends State<PasswordGenScreen> {
  String pass = "Tap Generate";
  void _genPass() {
    const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*";
    setState(() => pass = List.generate(12, (index) => chars[Random().nextInt(chars.length)]).join());
  }
  @override
  Widget build(BuildContext context) {
    return _buildToolScaffold("PASS GEN", Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(pass, style: const TextStyle(color: Colors.redAccent, fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: _genPass, child: const Text("GENERATE SECURE PASSWORD")),
      ],
    ));
  }
}

// 3. BMI CALCULATOR
class BMICalcScreen extends StatefulWidget { const BMICalcScreen({super.key}); @override State<BMICalcScreen> createState() => _BMICalcScreenState(); }
class _BMICalcScreenState extends State<BMICalcScreen> {
  final wCtrl = TextEditingController(); final hCtrl = TextEditingController(); String res = "";
  void _calc() {
    double? w = double.tryParse(wCtrl.text); double? h = double.tryParse(hCtrl.text);
    if (w != null && h != null) setState(() => res = "BMI: ${(w / ((h/100)*(h/100))).toStringAsFixed(1)}");
  }
  @override
  Widget build(BuildContext context) {
    return _buildToolScaffold("BMI CALC", Column(
      children: [
        TextField(controller: wCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Weight (KG)", labelStyle: TextStyle(color: Colors.white54))),
        TextField(controller: hCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Height (CM)", labelStyle: TextStyle(color: Colors.white54))),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _calc, child: const Text("CALCULATE")),
        const SizedBox(height: 30),
        Text(res, style: const TextStyle(color: Colors.redAccent, fontSize: 40, fontWeight: FontWeight.bold))
      ],
    ));
  }
}

// 4. DICE ROLLER
class DiceRollerScreen extends StatefulWidget { const DiceRollerScreen({super.key}); @override State<DiceRollerScreen> createState() => _DiceRollerScreenState(); }
class _DiceRollerScreenState extends State<DiceRollerScreen> {
  int dice = 1;
  @override
  Widget build(BuildContext context) {
    return _buildToolScaffold("DICE", Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 150, height: 150, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)), child: Center(child: Text("$dice", style: const TextStyle(color: Colors.black, fontSize: 80, fontWeight: FontWeight.bold)))),
        const SizedBox(height: 50),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20)), onPressed: () => setState(() => dice = Random().nextInt(6) + 1), child: const Text("ROLL", style: TextStyle(color: Colors.white, fontSize: 20))),
      ],
    ));
  }
}

// 5. DISCOUNT CALCULATOR
class DiscountCalcScreen extends StatefulWidget { const DiscountCalcScreen({super.key}); @override State<DiscountCalcScreen> createState() => _DiscountCalcScreenState(); }
class _DiscountCalcScreenState extends State<DiscountCalcScreen> {
  final pCtrl = TextEditingController(); final dCtrl = TextEditingController(); String res = "";
  void _calc() {
    double? p = double.tryParse(pCtrl.text); double? d = double.tryParse(dCtrl.text);
    if (p != null && d != null) setState(() => res = "Final Price: ₹${(p - (p * d / 100)).toStringAsFixed(2)}");
  }
  @override
  Widget build(BuildContext context) {
    return _buildToolScaffold("DISCOUNT", Column(
      children: [
        TextField(controller: pCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Original Price (₹)", labelStyle: TextStyle(color: Colors.white54))),
        TextField(controller: dCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Discount %", labelStyle: TextStyle(color: Colors.white54))),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _calc, child: const Text("CALCULATE")),
        const SizedBox(height: 30),
        Text(res, style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold))
      ],
    ));
  }
}

// 6. RANDOM NUMBER
class RandomNumScreen extends StatefulWidget { const RandomNumScreen({super.key}); @override State<RandomNumScreen> createState() => _RandomNumScreenState(); }
class _RandomNumScreenState extends State<RandomNumScreen> {
  int num = 0;
  @override
  Widget build(BuildContext context) {
    return _buildToolScaffold("RANDOM #", Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("1 to 100", style: TextStyle(color: Colors.grey[600], fontSize: 20)),
        const SizedBox(height: 20),
        Text("$num", style: const TextStyle(color: Colors.white, fontSize: 100, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        ElevatedButton(onPressed: () => setState(() => num = Random().nextInt(100) + 1), child: const Text("GENERATE"))
      ],
    ));
  }
}

// 7. AGE CALCULATOR & 8. MATH CALCULATOR (Placeholders mapped for quick completion)
class AgeCalcScreen extends StatelessWidget { const AgeCalcScreen({super.key}); @override Widget build(BuildContext context) => _buildToolScaffold("AGE CALC", const Center(child: Text("Age Logic Next", style: TextStyle(color: Colors.white)))); }
class SimpleCalcScreen extends StatelessWidget { const SimpleCalcScreen({super.key}); @override Widget build(BuildContext context) => _buildToolScaffold("MATH", const Center(child: Text("Calc Logic Next", style: TextStyle(color: Colors.white)))); }

// Helper for UI consistency
Widget _buildToolScaffold(String title, Widget body) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(title: Text(title), backgroundColor: Colors.black, elevation: 0),
    body: Padding(padding: const EdgeInsets.all(24.0), child: body),
  );
}
