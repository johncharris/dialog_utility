import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/pages/character_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  int? _selectedKey;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: DbManager.instance.characters.listenable(),
        builder: (context, value, child) => Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Scaffold(
                    floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          value.add(Character("Nameless", "empty"));
                        },
                        child: const Icon(Icons.add)),
                    body: ListView.builder(
                      itemCount: DbManager.instance.characters.keys.length,
                      itemBuilder: (context, index) {
                        var key = DbManager.instance.characters.keyAt(index);
                        var char = DbManager.instance.characters.getAt(index);
                        return ListTile(
                          onTap: () => setState(() => _selectedKey = key),
                          selected: _selectedKey == key,
                          title: Text(char!.name),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _showDeleteDialog(char),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (_selectedKey != null)
                  CharacterDetailPage(
                    _selectedKey!,
                    key: ValueKey(_selectedKey),
                  )
              ],
            ));
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
    await character.delete();

    if (!mounted) return;

    Navigator.pop(context);
  }
}
