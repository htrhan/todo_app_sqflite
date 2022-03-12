import 'package:flutter/material.dart';
import 'package:todo_app_sqflite/core/db_helper.dart';
import 'package:todo_app_sqflite/model/notes_model.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  List<Notes> notes = [];
  bool isLoading = false;

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getNotes();
  }

  void getNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : notes.isEmpty
              ? const Center(child: Text("Notes Not found"))
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) => Card(
                    color: Colors.blueGrey,
                    elevation: 10,
                    child: ListTile(
                      onTap: () {
                        print(notes[index].id);
                      },
                      leading: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => updateNote(
                                  notes[index].title ?? "",
                                  notes[index].description ?? "",
                                  notes[index].id ?? 0),
                            );
                          },
                          icon: const Icon(Icons.note_alt_sharp)),
                      title: Text(notes[index].title ?? ""),
                      subtitle: Text(notes[index].description ?? ""),
                      trailing: IconButton(
                          onPressed: () {
                            deleteNote(notes[index].id!);
                          },
                          icon: const Icon(Icons.delete_rounded)),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => addNotesDialog(),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 36,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }

  Dialog addNotesDialog() => Dialog(
        elevation: 100,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextFormField(
                controller: controllerTitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: "Title"),
              ),
              const SizedBox(),
              TextFormField(
                controller: controllerDescription,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: "Description"),
              ),
              const Spacer(
                flex: 3,
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addNote(Notes(
                        title: controllerTitle.text,
                        description: controllerDescription.text));
                  }
                },
                child: const Text(
                  "Add Notes",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.white),
                  elevation: MaterialStateProperty.all<double?>(100),
                ),
              ),
            ]),
          ),
        ),
      );

  Dialog updateNote(String title, String description, int id) => Dialog(
        elevation: 100,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextFormField(
                controller: controllerTitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: "title"),
              ),
              const SizedBox(),
              TextFormField(
                controller: controllerDescription,
                validator: (value) =>
                    value!.isEmpty ? "description cannot be null" : null,
                decoration: const InputDecoration(hintText: "description"),
              ),
              const Spacer(
                flex: 3,
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateNotes(
                      Notes.withId(
                          title: controllerTitle.text,
                          description: controllerDescription.text,
                          id: id),
                    );
                  }
                },
                child: const Text(
                  "Update Notes",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.white),
                  elevation: MaterialStateProperty.all<double?>(100),
                ),
              ),
            ]),
          ),
        ),
      );
  void addNote(Notes note) async {
    await NotesDatabase.instance.addNotes(note);
    setState(() {
      getNotes();
      controllerDescription.text = "";
      controllerTitle.text = "";
      print(note.id);
    });
    Navigator.pop(context);
  }

  Future<int?> updateNotes(Notes note) async {
    await NotesDatabase.instance.updateNotes(note);
    setState(() {
      getNotes();
      controllerDescription.text = "";
      controllerTitle.text = "";
      print(note.id);
    });
    Navigator.pop(context);
  }

  Future<int?> deleteNote(int id) async {
    await NotesDatabase.instance.deleteNotes(id);
    setState(
      () => getNotes(),
    );
  }
}
