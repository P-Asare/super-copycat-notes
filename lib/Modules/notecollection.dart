import 'package:flutter/material.dart';
import 'package:simple_notes/Modules/database.dart';
import 'package:simple_notes/Modules/note.dart';

class NoteCollection extends ChangeNotifier {
  Database db = Database(); // Database creation

  /// This calss serves as a collection of each
  /// note that has been created and exists
  List<Note> allNotes = [];

  /// load database values on mobile app
  void initializeNotes() {
    allNotes = db.loadNotes();
  }

  /// method to add new notes to all
  /// available notes
  void addNote(Note note) {
    allNotes.add(note);
    db.saveNotes(allNotes);
    notifyListeners();
  }

  /// Getters to return list holding all
  /// created notes
  List<Note> getAllNotes() {
    return allNotes;
  }

  /// Update an existing note with a new
  /// text
  void updateNote(int id, String text) {
    // check if id already exists
    for (int i = 0; i < allNotes.length; i++) {
      if (allNotes[i].id == id) {
        allNotes[i].text = text;
      }
    }

    // make update to note
    db.saveNotes(allNotes);
    notifyListeners();
  }

  /// remove a specified note from list
  void removeNote(Note note) {
    allNotes.remove(note);

    // make update to note
    db.saveNotes(allNotes);
    notifyListeners();
  }
}
