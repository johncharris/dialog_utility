import 'dart:async';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:darq/darq.dart';
import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/character_picture.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/conversation_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darq/darq.dart';

class ConversationViewer extends StatefulWidget {
  const ConversationViewer({required this.controller, super.key});
  final ConversationViewerController controller;

  @override
  State<ConversationViewer> createState() => _ConversationViewerState();
}

class _ConversationViewerState extends State<ConversationViewer> {
  Conversation? conversation;

  _DisplayCharacter? leftCharacter;
  _DisplayCharacter? rightCharacter;

  TextAlign _lastAlign = TextAlign.center;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.controller.indexStream,
        builder: (context, snapshot) {
          var textAlign = TextAlign.center;

          var line = widget.controller.currentLine;
          if (line?.characterId != null) {
// assign the character based on left or right being availible
            if (leftCharacter?.character?.id == line!.characterId) {
              textAlign = TextAlign.left;
            } else if (rightCharacter?.character?.id == line.characterId) {
              textAlign = TextAlign.right;
            } else {
              // No existing character was found we need to add one.
              var lineCharacter = widget.controller.characters!.firstWhereOrDefault((c) => c.id == line.characterId);
              if (_lastAlign != TextAlign.left) {
                leftCharacter = _DisplayCharacter(lineCharacter, line.characterName ?? '',
                    lineCharacter?.pictures.firstWhereOrDefault((value) => value.id == line.characterPicId));
                textAlign = TextAlign.left;
                _lastAlign = TextAlign.left;
              } else {
                rightCharacter = _DisplayCharacter(lineCharacter, line.characterName ?? '',
                    lineCharacter?.pictures.firstWhereOrDefault((value) => value.id == line.characterPicId));
                textAlign = TextAlign.right;
                _lastAlign = TextAlign.right;
              }
            }
          }

          return FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.accents.first, width: 1)),
                width: 1920,
                height: 1080,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                          child: _getCharacterView(leftCharacter, line?.characterId == leftCharacter?.character?.id)),
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(
                          widget.controller.currentLine?.text ?? '',
                          textAlign: textAlign,
                          style: GoogleFonts.comicNeue(fontSize: 36),
                        )),
                    Expanded(
                      child: _getCharacterView(rightCharacter, line?.characterId == rightCharacter?.character?.id),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _getCharacterView(_DisplayCharacter? character, bool focused) {
    if (character == null) return Container();

    var imageUrl = character.characterPic?.imageUrl ?? '';
    if (imageUrl.isEmpty) {
      imageUrl = character.character?.pictures
              .firstWhereOrDefault((value) => value.id == character.character?.defaultPictureId)
              ?.imageUrl ??
          '';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 320, height: 320, child: imageUrl.isEmpty ? Container() : Image.network(imageUrl)),
        Text(
          character.characterName.isNotEmpty ? character.characterName : character.character?.name ?? '',
          style: GoogleFonts.comicNeue(fontSize: 36),
        )
      ],
    ).animate(target: focused ? 1 : 0).scaleXY(end: 1.1).fade(begin: .8, end: 1);
  }
}

class _DisplayCharacter {
  Character? character;
  String characterName;
  CharacterPicture? characterPic;

  _DisplayCharacter(this.character, this.characterName, this.characterPic);
}

class ConversationViewerController {
  final String conversationId;

  Conversation? conversation;
  List<ConversationLine>? lines;
  List<Character>? characters;

  final indexStreamController = StreamController<int>.broadcast();
  Stream<int> get indexStream => indexStreamController.stream;

  int index = 0;

  ConversationLine? get previousLine {
    if (lines == null || index == 0) return null;
    return lines![index - 1];
  }

  ConversationLine? get currentLine {
    if (lines == null) return null;
    if (lines!.length < index) return null;
    return lines![index];
  }

  ConversationLine? get nextLine {
    if (lines == null || index >= lines!.length + 1) return null;
    return lines![index + 1];
  }

  bool next() {
    if (nextLine == null) return false;

    index++;
    indexStreamController.add(index);
    return true;
  }

  ConversationViewerController(this.conversationId) {
    _loadConversation();
  }

  Future _loadConversation() async {
    characters ??=
        (await charactersRef.get()).docs.map((e) => Character.fromJson(e.data() as dynamic)..id = e.id).toList();
    conversation = Conversation.fromJson((await conversationsRef.doc(conversationId).get() as dynamic).data());
    if (conversation == null) return;

    lines = conversation!.lines
        .toList()
        .orderBy(
          (element) => element.sortOrder,
        )
        .toList();

    index = 0;
    indexStreamController.add(index);
  }
}
