import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/conversation_line.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    return ValueListenableBuilder(
        valueListenable: DbManager.instance.conversations.listenable(keys: [widget.id]),
        builder: (context, value, child) => ValueListenableBuilder(
              valueListenable: DbManager.instance.characters.listenable(),
              builder: (context, characterBox, child) {
                final conversation = value.get(widget.id)!;
                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        var line = ConversationLine('');
                        await DbManager.instance.conversationLines.add(line);
                        conversation.lines.add(line);
                        await conversation.save();
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
                                  conversation.save();
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: conversation.lines.length,
                                  itemBuilder: (context, index) {
                                    var line = conversation.lines[index];
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
                                                  : line.character?.name ?? '',
                                            )));
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
                                            onPressed: () => _importDialog(conversation), icon: const Icon(Icons.send))
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
                      if (_selectedLine != null) _getLineEditor(characterBox)
                    ],
                  ),
                );
              },
            ));
  }

  SizedBox _getLineEditor(Box<Character> characterBox) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => _showCharacterPicSelectDialog(_selectedLine!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedLine!.characterPic == null)
                    const Icon(
                      Icons.person,
                      size: 300,
                    ),
                  if (_selectedLine!.characterPic != null)
                    SizedBox(width: 300, height: 300, child: Image.memory(_selectedLine!.characterPic!.bytes)),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                      decoration: const InputDecoration(labelText: "Character"),
                      value: _selectedLine!.character,
                      items: [
                            const DropdownMenuItem<Character>(
                              value: null,
                              child: Text(''),
                            )
                          ] +
                          characterBox.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ))
                              .toList(),
                      onChanged: (newValue) async {
                        _selectedLine!.character = newValue;
                        await _selectedLine!.save();
                        setState(() {});
                      }),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: _selectedLine!.characterName,
                    onChanged: (value) async {
                      _selectedLine!.characterName = value;
                      await _selectedLine!.save();
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
                  await _selectedLine!.save();
                  setState(() {});
                })
          ],
        ),
      ),
    );
  }

  _importDialog(Conversation conversation) async {
    final allCharacters = DbManager.instance.characters.values.toList();

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
      }

      var conversationLine = ConversationLine(
        text,
        character: character,
        characterName: characterName,
      );

      await DbManager.instance.conversationLines.add(conversationLine);

      conversation.lines.add(conversationLine);
    }
    await conversation.save();
  }

  _showCharacterPicSelectDialog(ConversationLine conversationLine) {}
}
