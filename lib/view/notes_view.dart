import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (c, i) => const Card(
          color: Colors.blueGrey,
          elevation: 10,
          child: ListTile(
            leading: Icon(Icons.note_alt_sharp),
            title: Text("New Todo"),
            subtitle: Text("asasas"),
            trailing: Icon(Icons.delete_rounded),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 36,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }
}
