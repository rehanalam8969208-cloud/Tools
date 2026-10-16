import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

class MirrorHomeScreen extends StatefulWidget {
  const MirrorHomeScreen({super.key});

  @override
  State<MirrorHomeScreen> createState() => _MirrorHomeScreenState();
}

class _MirrorHomeScreenState extends State<MirrorHomeScreen> {
  List<FileSystemEntity> _notes = [];
  String _folderPath = "/storage/emulated/0/MirrorNotes";
  
  // Game Variables
  double ballX = 0;
  double ballY = -1.0; 
  double ballVelocityX = 0.015;
  double ballVelocityY = 0.02;
  double paddleX = 0; 
  Timer? gameTimer;
  bool isGameRunning = true;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoad();
    _startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted && isGameRunning) {
        setState(() {
          ballX += ballVelocityX;
          ballY += ballVelocityY;

          if (ballX <= -1 || ballX >= 1) {
            ballVelocityX = -ballVelocityX;
          }
          if (ballY <= -1) {
            ballVelocityY = -ballVelocityY;
          }

          if (ballY >= 0.85 && ballY <= 0.9) {
            if (ballX >= paddleX - 0.4 && ballX <= paddleX + 0.4) {
              ballVelocityY = -ballVelocityY.abs(); 
              HapticFeedback.lightImpact(); 
            }
          }

          if (ballY > 1.2) {
            ballY = -1; 
            ballX = 0;
          }
        });
      }
    });
  }

  Future<void> _requestPermissionAndLoad() async {
    var status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final folder = Directory(_folderPath);
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    setState(() {
      _notes = folder.listSync().where((item) {
        String name = item.uri.pathSegments.last;
        return !name.startsWith('.') && item is File;
      }).toList();
    });
  }

  Future<void> _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File pickedFile = File(result.files.single.path!);
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              NoteEditorScreen(noteFile: pickedFile, folderPath: _folderPath),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
      _requestPermissionAndLoad(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "[ MIRROR ]",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open, color: Colors.white, size: 28),
            onPressed: _openFileExplorer, 
          )
        ],
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            paddleX += details.delta.dx / (MediaQuery.of(context).size.width / 2);
            if (paddleX < -1) paddleX = -1;
            if (paddleX > 1) paddleX = 1;
          });
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF000000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 110, bottom: 100, left: 16, right: 16),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  File file = File(_notes[index].path);
                  String fileName = file.uri.pathSegments.last; 
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                      ),
                      child: Text(
                        fileName,
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            Container(
              alignment: Alignment(ballX, ballY),
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyanAccent,
                  boxShadow: [
                    BoxShadow(color: Colors.cyanAccent.withOpacity(0.8), blurRadius: 15, spreadRadius: 5),
                  ]
                ),
              ),
            ),

            Container(
              alignment: Alignment(paddleX, 0.9), 
              child: Container(
                width: 120,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 10, spreadRadius: 2),
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.15),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditorScreen(folderPath: _folderPath)));
          _requestPermissionAndLoad();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class NoteEditorScreen extends StatefulWidget {
  final File? noteFile;
  final String folderPath;
  const NoteEditorScreen({super.key, this.noteFile, required this.folderPath});
  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.noteFile != null) {
      _titleController.text = widget.noteFile!.uri.pathSegments.last; 
      _contentController.text = widget.noteFile!.readAsStringSync();
    }
  }
  Future<void> _saveNote() async {
    String title = _titleController.text.trim();
    if (title.isEmpty) title = "Untitled_${DateTime.now().millisecondsSinceEpoch}";
    File newFile = File('${widget.folderPath}/$title');
    await newFile.writeAsString(_contentController.text);
    if (widget.noteFile != null && widget.noteFile!.path != newFile.path) {
      await widget.noteFile!.delete();
    }
    if (mounted) Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, actions: [IconButton(icon: const Icon(Icons.check), onPressed: _saveNote)]),
      body: SafeArea(
        child: Column(
          children: [
            TextField(controller: _titleController, style: const TextStyle(color: Colors.white, fontSize: 24)),
            Expanded(child: TextField(controller: _contentController, style: const TextStyle(color: Colors.white), maxLines: null, expands: true)),
          ],
        ),
      ),
    );
  }
}
