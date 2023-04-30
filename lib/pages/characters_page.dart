import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/pages/character_detail_page.dart';
import 'package:flutter/material.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  Character? _selected;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('characters').snapshots(),
      builder: (context, snapshot) {
        final characters = snapshot.hasData
            ? snapshot.data!.docs.map((e) => Character.fromJson(e.data())..id = e.id).toList()
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
