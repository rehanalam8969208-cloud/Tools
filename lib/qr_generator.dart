import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({super.key});

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  final TextEditingController _textController = TextEditingController();
  String qrData = "https://flutter.dev"; // Default QR text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Code Generator")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Enter Text or Link", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  qrData = value.isEmpty ? "https://flutter.dev" : value;
                });
              },
              decoration: InputDecoration(
                hintText: "E.g. https://google.com or Your Name",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white54),
                  onPressed: () {
                    _textController.clear();
                    setState(() { qrData = "https://flutter.dev"; });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            // 🔥 Yahan QR Code ban raha hai 🔥
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 20)],
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 220.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Your QR code updates automatically as you type!",
              style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
