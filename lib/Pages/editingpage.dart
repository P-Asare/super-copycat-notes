import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/Modules/notecollection.dart';
import '../Modules/note.dart';

class EditingPage extends StatefulWidget {
  final Note note;
  final bool isNew;

  const EditingPage({
    super.key,
    required this.note,
    required this.isNew,
  });

  @override
  State<EditingPage> createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    loadExistingNote();
  }

  /// Load the contents of an already existing note
  void loadExistingNote() {
    Document doc = Document()..insert(0, widget.note.text);

    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  /// Add new note to list of notes
  void addNewNote(BuildContext context) {
    int id = Provider.of<NoteCollection>(context, listen: false)
        .getAllNotes()
        .length;
    String text = _controller.document.toPlainText();

    Provider.of<NoteCollection>(context, listen: false)
        .addNote(Note(id: id, text: text));
  }

  /// Update existing note with edited text
  void updateExisitingNote(BuildContext context) {
    Provider.of<NoteCollection>(context, listen: false)
        .updateNote(widget.note.id, _controller.document.toPlainText());
  }

  /// Remove existing note when it is empty
  void removeNote(BuildContext context) {
    Provider.of<NoteCollection>(context, listen: false).removeNote(widget.note);
  }

  /// method to determine whether note is
  /// edited on created as a new note when
  /// back button is clicked
  void returnHome(BuildContext context) {
    // confirm if new note would be created or old will be edited
    if (!_controller.document.isEmpty() && widget.isNew) {
      addNewNote(context);
    } else if (_controller.document.isEmpty() && !widget.isNew) {
      // TODO: Fix bug for when old note is left empty
      removeNote(context);
    } else {
      updateExisitingNote(context);
    }

    // return to homepage
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[200],
        leading: IconButton(
          onPressed: () => returnHome(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          QuillToolbar.basic(
            controller: _controller,
            showSuperscript: false,
            showSubscript: false,
            showLink: false,
            showBackgroundColorButton: false,
            showDirection: false,
            showSearchButton: false,
            showColorButton: false,
            showDividers: false,
            showQuote: false,
            showHeaderStyle: false,
            showSmallButton: false,
            showClearFormat: false,
            showCodeBlock: false,
            showInlineCode: false,
            showFontFamily: false,
            showStrikeThrough: false,
            showListCheck: false,
            showRedo: false,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Expanded(
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
