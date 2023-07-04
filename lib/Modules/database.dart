//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'note.dart';

/// Class to serve as a storage for notes
class Database {
  final _myBox = Hive.box('hive_database');

  /// Load Notes from hive database to app
  List<Note> loadNotes() {
    List<Note> savedMobileNotes = [];

    if (_myBox.get('ALLNOTES') != null) {
      List<dynamic> savedDatabaseNotes = _myBox.get('ALLNOTES');

      // Create individual notes from hive database
      for (int i = 0; i < savedDatabaseNotes.length; i++) {
        Note note = Note(
          id: savedDatabaseNotes[i][0],
          text: savedDatabaseNotes[i][1],
        );

        // Add to mobile list storage
        savedMobileNotes.add(note);
      }
    } else {
      savedMobileNotes.add(Note(id: 0, text: 'FIRST NOTE'));
    }

    return savedMobileNotes;
  }

  /// Save the new note list to hive database list
  void saveNotes(List<Note> mobileList) {
    List<List<dynamic>> hiveList = [];

    for (var note in mobileList) {
      // Add each note from mobile to list to push to database
      String text = note.text;
      int id = note.id;

      hiveList.add([id, text]);
    }

    // Write hiveList to box database
    _myBox.put('ALLNOTES', hiveList);
  }
}
