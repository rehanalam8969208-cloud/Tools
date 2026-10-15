import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MirrorHomeScreen extends StatefulWidget {
  const MirrorHomeScreen({super.key});

  @override
  State<MirrorHomeScreen> createState() => _MirrorHomeScreenState();
}

class _MirrorHomeScreenState extends State<MirrorHomeScreen> {
  List<FileSystemEntity> _notes = [];
  String _folderPath = "";

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Storage me MirrorNotes folder dhundna aur files load karna
  Future<void> _loadNotes() async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      final folder = Directory('${directory.path}/MirrorNotes');
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }
      setState(() {
        _folderPath = folder.path;
        _notes = folder.listSync().where((item) => item.path.endsWith('.txt')).toList();
      });
    }
  }

  Future<void> _deleteNote(File file) async {
    await file.delete();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("[ MIRROR ]"),
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text(
                "NO NOTES FOUND.\nCREATE A REFLECTION.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 16, letterSpacing: 2),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                File file = File(_notes[index].path);
                String fileName = file.uri.pathSegments.last.replaceAll('.txt', '');

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0F0F),
                    border: Border.all(color: Colors.white24, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      fileName.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1),
                    ),
                    subtitle: const Text("TXT DOCUMENT", style: TextStyle(color: Colors.white38, fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _deleteNote(file),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NoteEditorScreen(noteFile: file, folderPath: _folderPath)),
                      );
                      _loadNotes(); // Edit hone ke baad refresh
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)), // Square button for techy look
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditorScreen(folderPath: _folderPath)),
          );
          _loadNotes();
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

// ==========================================
// EDITOR SCREEN (Create & Edit Note)
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
      // Agar purana note hai, toh uska naam aur content load karo
      _titleController.text = widget.noteFile!.uri.pathSegments.last.replaceAll('.txt', '');
      _contentController.text = widget.noteFile!.readAsStringSync();
    }
  }

  Future<void> _saveNote() async {
    String title = _titleController.text.trim();
    String content = _contentController.text;

    if (title.isEmpty) {
      title = "UNTITLED_${DateTime.now().millisecondsSinceEpoch}";
    }

    // Nayi file banao ya purani ko overwrite karo
    File newFile = File('${widget.folderPath}/$title.txt');
    await newFile.writeAsString(content);

    // Agar title change hua hai, toh purani file delete kar do
    if (widget.noteFile != null && widget.noteFile!.path != newFile.path) {
      await widget.noteFile!.delete();
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EDIT NOTE"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined, color: Colors.white),
            onPressed: _saveNote,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "NOTE TITLE",
                hintStyle: TextStyle(color: Colors.white24),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            
            // Content Input
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _contentController,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: "TYPE YOUR THOUGHTS HERE...",
                    hintStyle: TextStyle(color: Colors.white24),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                ),
                onPressed: _saveNote,
                child: const Text("SAVE TO STORAGE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
