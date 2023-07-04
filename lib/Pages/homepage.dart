import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/Modules/note.dart';
import 'package:simple_notes/Modules/notecollection.dart';
import 'package:simple_notes/Pages/editingpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// initialize state of page
  @override
  void initState() {
    super.initState();
    Provider.of<NoteCollection>(context, listen: false).initializeNotes();
  }

  /// Method to open new editing page
  void openEditor(BuildContext context) {
    int id = Provider.of<NoteCollection>(context, listen: false)
        .getAllNotes()
        .length;
    Note newNote = Note(id: id, text: '');

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditingPage(
            note: newNote,
            isNew: true,
          ),
        ));
  }

  /// Open an existing note object
  void openNote(Note note, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditingPage(note: note, isNew: false),
        ));
  }

  /// Delete an existing note
  void deleteNote(Note note) {
    Provider.of<NoteCollection>(context, listen: false).removeNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCollection>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: Colors.green,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 55,
                        left: 15,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 3,
                        right: 3,
                      ),
                      child: (value.getAllNotes().isEmpty)
                          ? const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'Nothing here...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : CupertinoListSection.insetGrouped(
                              backgroundColor: Colors.green,
                              children: List.generate(
                                Provider.of<NoteCollection>(context,
                                        listen: false)
                                    .getAllNotes()
                                    .length,
                                (index) => CupertinoListTile(
                                  backgroundColor: Colors.green[200],
                                  title: Text(Provider.of<NoteCollection>(
                                          context,
                                          listen: false)
                                      .getAllNotes()[index]
                                      .text),
                                  onTap: () {
                                    openNote(
                                      Provider.of<NoteCollection>(
                                        context,
                                        listen: false,
                                      ).getAllNotes()[index],
                                      context,
                                    );
                                  },
                                  trailing: IconButton(
                                    onPressed: () {
                                      deleteNote(value.getAllNotes()[index]);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => openEditor(context),
                backgroundColor: Colors.green[200],
                child: const Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
              ),
            ));
  }
}
