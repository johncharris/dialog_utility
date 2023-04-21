import 'dart:typed_data';

import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/conversation_line.dart';
import 'package:dialog_utility/pages/character_pic_select_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:darq/darq.dart';

class ConversationDetailPage extends StatefulWidget {
  const ConversationDetailPage(this.id, {super.key});
  final int id;

  @override
  State<ConversationDetailPage> createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  String _dialog = '';
  ConversationLine? _selectedLine;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbManager.instance.isar.conversations.watchObject(widget.id, fireImmediately: true),
        builder: (context, value) => StreamBuilder(
              stream: DbManager.instance.isar.characters.where().watch(fireImmediately: true),
              builder: (context, charactersSnapshot) {
                if (!value.hasData || !charactersSnapshot.hasData) return Container();

                final conversation = value.data!;
                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        var line = ConversationLine('');
                        conversation.lines.add(line);
                        await DbManager.instance.isar.writeTxn(() async {
                          await DbManager.instance.isar.conversationLines.put(line);
                          await conversation.lines.save();
                        });
                      },
                      child: const Icon(Icons.add)),
                  body: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                decoration: const InputDecoration(hintText: "Conversation Name"),
                                initialValue: conversation.name,
                                onChanged: (newValue) {
                                  conversation.name = newValue;
                                  _saveConversation(conversation);
                                },
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder(
                                  future: conversation.lines.load(),
                                  builder: (context, _) {
                                    var lines = conversation.lines.orderBy((element) => element.sortOrder).toList();
                                    return ListView.builder(
                                        itemCount: lines.length,
                                        itemBuilder: (context, index) {
                                          var line = lines[index];
                                          return Container(
                                              decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [Colors.transparent, Colors.grey],
                                                      stops: [0, 1],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter)),
                                              child: ListTile(
                                                  onTap: () => setState(() => _selectedLine = line),
                                                  selected: _selectedLine == line,
                                                  title: Text(line.text),
                                                  leading: Text(
                                                    ((line.characterName ?? '').isNotEmpty)
                                                        ? line.characterName!
                                                        : line.character.value?.name ?? '',
                                                  )));
                                        });
                                  }),
                            ),
                            ExpansionTile(
                              title: const Text("Import Dialog"),
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0, 8, 42, 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            minLines: 5,
                                            maxLines: 20,
                                            onChanged: (value) => _dialog = value,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () => _importDialog(conversation, charactersSnapshot.data!),
                                            icon: const Icon(Icons.send))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      if (_selectedLine == null)
                        const SizedBox(
                          width: 400,
                        ),
                      if (_selectedLine != null) _getLineEditor(charactersSnapshot.data!)
                    ],
                  ),
                );
              },
            ));
  }

  _saveConversation(Conversation conversation) async {
    await DbManager.instance.isar.writeTxn(() async => await DbManager.instance.isar.conversations.put(conversation));
  }

  SizedBox _getLineEditor(List<Character> characters) {
    return SizedBox(
      key: ValueKey(_selectedLine),
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              // onTap: () => _selectedLine!.character == null ? null : _showCharacterPicSelectDialog(_selectedLine!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_selectedLine!.characterPic.isLoaded || _selectedLine!.characterPic.value == null)
                    const Icon(
                      Icons.person,
                      size: 300,
                    ),
                  if (_selectedLine!.characterPic.isLoaded && _selectedLine!.characterPic.value != null)
                    SizedBox(
                        width: 300,
                        height: 300,
                        child: Image.memory(Uint8List.fromList(_selectedLine!.characterPic.value!.bytes))),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: "Character"),
                      value: _selectedLine!.character.value?.id,
                      items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text(''),
                            )
                          ] +
                          characters
                              .map((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.name),
                                  ))
                              .toList(),
                      onChanged: (newValue) async {
                        _selectedLine!.character.value =
                            characters.firstWhereOrDefault((element) => element.id == newValue);
                        _saveLine();
                        setState(() {});
                      }),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: _selectedLine!.characterName,
                    onChanged: (value) async {
                      _selectedLine!.characterName = value;
                      await _saveLine();
                      setState(() {});
                    },
                    decoration: const InputDecoration(labelText: "Name Override"),
                  ),
                )
              ],
            ),
            TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                initialValue: _selectedLine!.text,
                minLines: 10,
                maxLines: 20,
                onChanged: (newValue) async {
                  _selectedLine!.text = newValue;
                  await _saveLine();
                  setState(() {});
                })
          ],
        ),
      ),
    );
  }

  Future _saveLine() async {
    if (_selectedLine == null) return;

    await DbManager.instance.isar.writeTxn(() async {
      await _selectedLine!.character.save();
      DbManager.instance.isar.conversationLines.put(_selectedLine!);
    });
  }

  _importDialog(Conversation conversation, List<Character> characters) async {
    final allCharacters = await DbManager.instance.isar.characters.where().findAll();

    final newLines = <ConversationLine>[];

    for (var line in _dialog.split('\n').map((e) => e.trim()).where((element) => element.isNotEmpty).toList()) {
      Character? character;
      String? characterName;
      String text = '';
      var lineParts = line.split(":");
      if (lineParts.length > 1) {
        characterName = lineParts.first.trim();

        character = allCharacters.cast().firstWhere(
              (element) => element.handle == characterName,
              orElse: () => null,
            );

        if (character != null) {
          characterName = null;
        }

        text = line.substring(line.indexOf(":") + 1).trim();
      } else {
        text = line;
      }

      var conversationLine = ConversationLine(
        text,
        characterName: characterName,
      )..character.value = character;
      newLines.add(conversationLine);
    }

    var index = conversation.lines.isEmpty ? 0 : conversation.lines.map((e) => e.sortOrder).max();
    for (var line in newLines) {
      line.sortOrder = index++;
      conversation.lines.add(line);
    }
    await DbManager.instance.isar.writeTxn(() async {
      await DbManager.instance.isar.conversationLines.putAll(newLines);
      await conversation.lines.save();
    });

    // conversation.lines.add(conversationLine);
    await _saveConversation(conversation);
  }

  // _showCharacterPicSelectDialog(ConversationLine conversationLine) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => CharacterPicSelectDialog(conversationLine),
  //   );
  // }
}
