import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/project.dart';
import 'package:dialog_utility/pages/character_detail_page.dart';
import 'package:flutter/material.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage(this.project, {super.key});

  final Project project;

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  Character? _selected;

  late CollectionReference charactersRef;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    charactersRef = FirebaseFirestore.instance.collection('projects/${widget.project.id}/characters');
    return StreamBuilder(
      stream: charactersRef.orderBy("name").snapshots(),
      builder: (context, snapshot) {
        final characters = snapshot.hasData
            ? snapshot.data!.docs.map((e) => Character.fromJson(e.data() as dynamic)..id = e.id).toList()
            : <Character>[];
        return Row(
          children: [
            SizedBox(
              width: 300,
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      var ref = await charactersRef.add(Character(name: 'unnamed', handle: '', pictures: []).toJson());
                    },
                    child: const Icon(Icons.add)),
                body: ListView.builder(
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    var char = characters[index];
                    return ListTile(
                      onTap: () => setState(() => _selected = char),
                      selected: _selected == char,
                      title: Text(char.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(char),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_selected != null)
              CharacterDetailPage(
                widget.project,
                _selected!,
                key: ValueKey(_selected),
              )
          ],
        );
      },
    );
  }

  _showDeleteDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Character"),
        content: Text("Are you sure you want to delete ${character.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Don't Delete")),
          TextButton(onPressed: () => _deleteCharacter(character), child: Text("Delete ${character.name}"))
        ],
      ),
    );
  }

  _deleteCharacter(Character character) async {
    // await DbManager.instance.isar.writeTxn((isar) async => await isar.characters.delete(character.id));

    // if (!mounted) return;

    // Navigator.pop(context);
  }
}
