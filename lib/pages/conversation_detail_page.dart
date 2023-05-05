import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/dialogs/share_conversation_dialog.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/conversation_line.dart';
import 'package:dialog_utility/models/project.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:darq/darq.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:dialog_utility/color_extensions.dart';

class ConversationDetailPage extends StatefulWidget {
  const ConversationDetailPage(this.project, this.id, {super.key});
  final Project project;
  final String id;

  @override
  State<ConversationDetailPage> createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  String _dialog = '';
  ConversationLine? _selectedLine;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.project.conversationsRef.doc(widget.id).snapshots(),
        builder: (context, value) => StreamBuilder(
              stream: widget.project.charactersRef.snapshots(),
              builder: (context, charactersSnapshot) {
                if (!value.hasData || !charactersSnapshot.hasData) return Container();

                final characters = charactersSnapshot.data!.docs
                    .map((e) => Character.fromJson(e.data() as Map<String, dynamic>)..id = e.id)
                    .toList();
                final conversation = Conversation.fromJson(value.data!.data() as Map<String, dynamic>)
                  ..id = value.data!.id;
                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        var line = ConversationLine('');
                        conversation.lines.add(line);
                        _saveConversation(conversation);
                      },
                      child: const Icon(Icons.add)),
                  body: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Builder(builder: (context) {
                                var lines = conversation.lines.orderBy((element) => element.sortOrder).toList();
                                return ListView.builder(
                                    itemCount: lines.length,
                                    itemBuilder: (context, index) {
                                      var line = lines[index];
                                      return Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [Colors.transparent, Colors.grey.withAlpha(32)],
                                                  stops: const [0, 1],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                          child: InkWell(
                                            onTap: () => setState(() => _selectedLine = line),
                                            child: Row(children: [
                                              SizedBox(
                                                width: 100,
                                                child: Column(
                                                  children: [
                                                    _getLineImage(line, characters),
                                                    Text(
                                                      ((line.characterName ?? '').isNotEmpty)
                                                          ? line.characterName!
                                                          : characters
                                                                  .firstWhereOrDefault(
                                                                      (value) => value.id == line.characterId)
                                                                  ?.name ??
                                                              '',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                margin: const EdgeInsets.all(8),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                                child: Text(line.text),
                                              ))
                                            ]),
                                            // selected: _selectedLine == line,
                                          ));
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
                                            onPressed: () => _importDialog(conversation, characters),
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
                      if (_selectedLine == null) _getConversationEditor(conversation),
                      if (_selectedLine != null) _getLineEditor(conversation, characters)
                    ],
                  ),
                );
              },
            ));
  }

  _saveConversation(Conversation conversation) async {
    await widget.project.conversationsRef.doc(conversation.id).set(conversation.toJson());
  }

  SizedBox _getLineEditor(Conversation conversation, List<Character> characters) {
    return SizedBox(
      key: ValueKey(_selectedLine),
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => _selectedLine!.characterId == null ? null : _showCharacterPicSelectDialog(_selectedLine!),
              child: SizedBox(height: 300, width: 300, child: _getLineImage(_selectedLine!, characters)),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Character"),
                      value: _selectedLine!.characterId,
                      items: [
                            const DropdownMenuItem<String>(
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
                        _selectedLine!.characterId = newValue;
                        _saveLine(conversation);
                      }),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: _selectedLine!.characterName,
                    onChanged: (value) async {
                      _selectedLine!.characterName = value;
                    },
                    onEditingComplete: () => _saveLine(conversation),
                    onTapOutside: (event) => _saveLine(conversation),
                    decoration: const InputDecoration(labelText: "Name Override"),
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _selectedLine!.text,
              minLines: 10,
              maxLines: 20,
              onChanged: (newValue) async {
                _selectedLine!.text = newValue;
                conversation.lines.firstWhere((element) => element.sortOrder == _selectedLine!.sortOrder).text =
                    newValue;
              },
              onEditingComplete: () async => await _saveLine(conversation),
              onTapOutside: (event) => _saveLine(conversation),
            )
          ],
        ),
      ),
    );
  }

  Widget _getLineImage(ConversationLine line, List<Character> characters) {
    var character = characters.firstWhereOrDefault((c) => c.id == line.characterId);

    String url = '';
    if (line.characterPicId != null) {
      url = characters
              .expand((element) => element.pictures)
              .firstWhereOrDefault((value) => value.id == line.characterPicId)
              ?.imageUrl ??
          '';
    }
    if (url.isEmpty && character != null) {
      url = characters
              .expand((element) => element.pictures)
              .firstWhereOrDefault((value) => value.id == character.defaultPictureId)
              ?.imageUrl ??
          '';
    }

    if (url.isEmpty) return Container();
    return Image.network(url);
  }

  Future _saveLine(Conversation conversation) async {
    await widget.project.conversationsRef.doc(conversation.id).set(conversation.toJson());
  }

  _importDialog(Conversation conversation, List<Character> characters) async {
    final newLines = <ConversationLine>[];

    for (var line in _dialog.split('\n').map((e) => e.trim()).where((element) => element.isNotEmpty).toList()) {
      Character? character;
      String? characterName;
      String text = '';
      var lineParts = line.split(":");
      if (lineParts.length > 1) {
        characterName = lineParts.first.trim();

        character = characters.firstWhereOrDefault(
          (element) => element.handle.toUpperCase() == characterName?.toUpperCase(),
        );

        if (character != null) {
          characterName = null;
        }

        text = line.substring(line.indexOf(":") + 1).trim();
      } else {
        text = line;
      }

      var conversationLine = ConversationLine(text, characterName: characterName, characterId: character?.id);
      newLines.add(conversationLine);
    }

    var index = conversation.lines.isEmpty ? 0 : conversation.lines.map((e) => e.sortOrder).max();
    for (var line in newLines) {
      line.sortOrder = index++;
      conversation.lines.add(line);
    }

    await _saveConversation(conversation);
  }

  _showCharacterPicSelectDialog(ConversationLine conversationLine) async {
    //   var selected = await showDialog<CharacterPicture>(
    //     context: context,
    //     builder: (context) => CharacterPicSelectDialog(conversationLine),
    //   );

    //   if (selected != null) {
    //     _selectedLine!.characterPic.value = selected;
    //     await _saveLine(characterPic: true);
    //   }
  }

  Widget _getConversationEditor(Conversation conversation) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: 400,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Conversation Name"),
                  initialValue: conversation.name,
                  onChanged: (newValue) {
                    conversation.name = newValue;
                    _saveConversation(conversation);
                  },
                ),
              ),
              IconButton(
                  onPressed: () => showDialog(
                        context: context,
                        builder: (context) =>
                            ShareConversationDialog(projectId: widget.project.id, conversation: conversation),
                      ),
                  icon: const Icon(Icons.share))
            ],
          ),
          FittedBox(
            child: SizedBox(
              width: 1920,
              height: 1080,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DropRegion(
                        formats: const [Formats.png, Formats.jpeg, Formats.svg],
                        onDropOver: (event) => DropOperation.copy,
                        onPerformDrop: (event) async {
                          final item = event.session.items.first;

                          final reader = item.dataReader!;
                          await _saveBackground(conversation, reader);
                        },
                        child: Image.network(
                          conversation.backgroundUrl,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 360,
                        color: HexColor.fromHex(conversation.textAreaBackgroundColor),
                      ))
                ],
              ),
            ),
          ),
          TextFormField(
            initialValue: conversation.textAreaBackgroundColor,
            onChanged: (value) {
              conversation.textAreaBackgroundColor = value;
              _saveConversation(conversation);
            },
          ),
        ],
      ),
    );
  }

  Future _saveBackground(Conversation conversation, DataReader reader) async {
    for (var format in [Formats.png, Formats.svg, Formats.jpeg]) {
      if (reader.canProvide(format)) {
        reader.getFile(format, (file) async {
          String ext = file.fileName!.substring(file.fileName!.lastIndexOf('.') + 1);
          var fileStream = file.readAll();
          var bytes = await fileStream;
          // upload image to Firebase Storage
          Reference storageRef = FirebaseStorage.instance.ref().child('backgrounds/${uuid.v4()}.$ext');
          UploadTask uploadTask = storageRef.putData(bytes, SettableMetadata(contentType: "image/$ext"));
          TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

          // get image URL
          var u = await snapshot.ref.getDownloadURL();
          setState(() {
            conversation.backgroundUrl = u;
          });

          await _saveConversation(conversation);
        });
      }
    }
  }
}
