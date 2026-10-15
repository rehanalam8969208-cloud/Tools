import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MirrorHomeScreen extends StatefulWidget {
  const MirrorHomeScreen({super.key});

  @override
  State<MirrorHomeScreen> createState() => _MirrorHomeScreenState();
}

class _MirrorHomeScreenState extends State<MirrorHomeScreen> {
  List<FileSystemEntity> _notes = [];
  String _folderPath = "/storage/emulated/0/MirrorNotes";

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
      // Sirf .txt files dikhao, hidden files (.apikey) nahi
      _notes = folder.listSync().where((item) => item.path.endsWith('.txt') && !item.path.split('/').last.startsWith('.')).toList();
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

  // API Key dalne wala Dialog Box
  Future<void> _showApiKeyDialog() async {
    TextEditingController keyController = TextEditingController();
    File keyFile = File("$_folderPath/.apikey.txt");
    
    // Purani key agar hai to textbox me dikhao
    if (await keyFile.exists()) {
      keyController.text = await keyFile.readAsString();
    }

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          title: Text("Set AI API Key", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: keyController,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Paste Google Gemini Key here...",
              hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.purpleAccent)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
              onPressed: () async {
                await keyFile.writeAsString(keyController.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("API Key Saved Successfully!"), backgroundColor: Colors.green),
                );
              },
              child: Text("Save", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      // Hamburger Menu (3 lines)
      drawer: Drawer(
        backgroundColor: const Color(0xFF0F172A).withOpacity(0.9),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
              ),
              child: Center(
                child: Text(
                  "[ MIRROR ]",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: 3),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.key, color: Colors.purpleAccent),
              title: Text("Set API Key", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
              subtitle: Text("For AI Magic", style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12)),
              onTap: () {
                Navigator.pop(context); // Menu band karo
                _showApiKeyDialog(); // Dialog kholo
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // 3-line icon color
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        title: Text(
          "Notes",
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: Container(
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
                  String fileName = file.uri.pathSegments.last.replaceAll('.txt', '');

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
            child: const Icon(Icons.edit, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// EDITOR SCREEN (AI Magic with Local Key)
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
  bool _isAiLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.noteFile != null) {
      _titleController.text = widget.noteFile!.uri.pathSegments.last.replaceAll('.txt', '');
      _contentController.text = widget.noteFile!.readAsStringSync();
    }
  }

  Future<void> _saveNote() async {
    String title = _titleController.text.trim();
    String content = _contentController.text;

    if (title.isEmpty) {
      title = "Untitled_${DateTime.now().millisecondsSinceEpoch}";
    }

    File newFile = File('${widget.folderPath}/$title.txt');
    await newFile.writeAsString(content);

    if (widget.noteFile != null && widget.noteFile!.path != newFile.path) {
      await widget.noteFile!.delete();
    }

    if (mounted) {
      HapticFeedback.lightImpact();
      Navigator.pop(context);
    }
  }

  // AI Magic Logic
  Future<void> _runAiMagic() async {
    File keyFile = File('${widget.folderPath}/.apikey.txt');
    String savedApiKey = "";
    
    if (await keyFile.exists()) {
      savedApiKey = await keyFile.readAsString();
    }

    if (savedApiKey.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please set API Key from the Home Menu first!"), backgroundColor: Colors.redAccent)
      );
      return;
    }

    setState(() => _isAiLoading = true);
    HapticFeedback.mediumImpact();

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: savedApiKey.trim());
      final currentText = _contentController.text;
      
      String prompt = currentText.isEmpty 
          ? "Write a very short, poetic, and creative note about deep thoughts or technology." 
          : "Enhance this text, fix grammar, make it sound more professional and stylish, but keep the original meaning: $currentText";

      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text != null) {
        setState(() {
          _contentController.text = response.text!.trim();
        });
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("AI Error: Connection Issue! Ensure internet is ON and API Key is valid."), backgroundColor: Colors.redAccent)
      );
    } finally {
      setState(() => _isAiLoading = false);
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
          _isAiLoading 
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.purpleAccent, strokeWidth: 2)),
              )
            : IconButton(
                icon: const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 28),
                onPressed: _runAiMagic,
                tooltip: "AI Magic",
              ),
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
