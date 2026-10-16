import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

class MirrorHomeScreen extends StatefulWidget {
  const MirrorHomeScreen({super.key});

  @override
  State<MirrorHomeScreen> createState() => _MirrorHomeScreenState();
}

class _MirrorHomeScreenState extends State<MirrorHomeScreen> {
  List<FileSystemEntity> _notes = [];
  String _folderPath = "/storage/emulated/0/MirrorNotes";
  
  // Ball ki position track karne ke liye variables
  double _ballX = 150.0;
  double _ballY = 300.0;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoad();
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
      // Ab saari files read karega, bas hidden files (jo '.' se shuru hoti hain) ko chhod kar
      _notes = folder.listSync().where((item) {
        String name = item.uri.pathSegments.last;
        return !name.startsWith('.') && item is File;
      }).toList();
    });
  }

  Future<void> _deleteNoteConfirm(File file) async {
    HapticFeedback.heavyImpact(); 
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          title: Text("Delete Note?", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          content: Text("Are you sure you want to delete this note permanently?", style: GoogleFonts.poppins(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () async {
                await file.delete();
                Navigator.pop(context);
                _requestPermissionAndLoad();
              },
              child: Text("Delete", style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Ungli ki position update karne ka function
  void _updateBallPosition(PointerEvent details) {
    setState(() {
      _ballX = details.position.dx - 25; // 25 ball ki aadhi width hai center karne ke liye
      _ballY = details.position.dy - 25;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        title: Text(
          "[ MIRROR ]",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3),
        ),
        centerTitle: true,
      ),
      // Listener se hum ungli ka touch track kar rahe hain
      body: Listener(
        onPointerDown: _updateBallPosition,
        onPointerMove: _updateBallPosition,
        behavior: HitTestBehavior.opaque,
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
              child: _notes.isEmpty
                  ? Center(
                      child: Text(
                        "No notes yet.\nTap + to create.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Colors.white38, fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 110, bottom: 100, left: 16, right: 16),
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        File file = File(_notes[index].path);
                        String fileName = file.uri.pathSegments.last; // Ab direct naam dikhega

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Hero(
                            tag: 'note_${file.path}',
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  HapticFeedback.lightImpact();
                                  await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => NoteEditorScreen(noteFile: file, folderPath: _folderPath),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(opacity: animation, child: child);
                                      },
                                    ),
                                  );
                                  _requestPermissionAndLoad(); 
                                },
                                onLongPress: () => _deleteNoteConfirm(file),
                                borderRadius: BorderRadius.circular(20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fileName,
                                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Long press to delete",
                                            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            // 🌟 THE TRACKING BALL 🌟
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100), // Smooth delay
              curve: Curves.easeOut,
              left: _ballX,
              top: _ballY,
              child: IgnorePointer( // Ball par click na ho, neeche pass ho
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6),
                        blurRadius: 25,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.4),
                        blurRadius: 50,
                        spreadRadius: 20,
                      ),
                    ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FloatingActionButton(
            backgroundColor: Colors.white.withOpacity(0.15),
            elevation: 0,
            onPressed: () async {
              HapticFeedback.mediumImpact();
              await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => NoteEditorScreen(folderPath: _folderPath),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
              _requestPermissionAndLoad();
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// EDITOR SCREEN (Without AI, No .txt extension)
// ==========================================
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
      _titleController.text = widget.noteFile!.uri.pathSegments.last; // Yahan se bhi .txt remove ka jhanjhat khatam
      _contentController.text = widget.noteFile!.readAsStringSync();
    }
  }

  Future<void> _saveNote() async {
    String title = _titleController.text.trim();
    String content = _contentController.text;

    if (title.isEmpty) {
      title = "Untitled_${DateTime.now().millisecondsSinceEpoch}";
    }

    // Yahan maine .txt hata diya hai, ab file exact title ke naam se save hogi
    File newFile = File('${widget.folderPath}/$title');
    await newFile.writeAsString(content);

    if (widget.noteFile != null && widget.noteFile!.path != newFile.path) {
      await widget.noteFile!.delete();
    }

    if (mounted) {
      HapticFeedback.lightImpact();
      Navigator.pop(context);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: _saveNote,
        ),
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blueAccent, size: 28),
            onPressed: _saveNote,
          )
        ],
      ),
      body: Hero(
        tag: widget.noteFile != null ? 'note_${widget.noteFile!.path}' : 'new_note',
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF000000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
                      decoration: InputDecoration(
                        hintText: "Title",
                        hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 32, fontWeight: FontWeight.w700),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: TextField(
                        controller: _contentController,
                        style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 18, height: 1.5),
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          hintText: "Start typing...",
                          hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 18),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
