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
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ConversationViewer extends StatefulWidget {
  const ConversationViewer({required this.controller, super.key});
  final ConversationViewerController controller;

  @override
  State<ConversationViewer> createState() => _ConversationViewerState();
}

class _ConversationViewerState extends State<ConversationViewer> {
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
              var lineCharacter = widget.controller.characters.firstWhereOrDefault((c) => c.id == line.characterId);
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

          return Builder(
            builder: (context) {
              final mq = MediaQuery.of(context);
              bool isTall = mq.size.height > mq.size.width;
              return isTall ? _getTallLayout(line, textAlign) : _getWideLayout(line, textAlign);
            },
          );
        });
  }

  Widget _getTallLayout(ConversationLine? line, TextAlign textAlign) {
    return Stack(
      children: [
        if (widget.controller.conversation.backgroundUrl.isNotEmpty)
          Positioned.fill(
            child: Image.network(
              widget.controller.conversation.backgroundUrl,
              fit: BoxFit.cover,
            ),
          ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                    child: SizedBox.expand(
                  child: FittedBox(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _getCharacterView(leftCharacter, true, line?.characterId == leftCharacter?.character?.id),
                  )),
                )),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: _getAnimatedDialogText(textAlign, true))),
                Expanded(
                    child: SizedBox.expand(
                        child: FittedBox(
                            child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _getCharacterView(rightCharacter, false, line?.characterId == rightCharacter?.character?.id),
                ))))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getWideLayout(ConversationLine? line, TextAlign textAlign) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.accents.first, width: 1)),
        width: 1920,
        height: 1080,
        child: Stack(
          children: [
            if (widget.controller.conversation.backgroundUrl.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  widget.controller.conversation.backgroundUrl,
                  fit: BoxFit.cover,
                ),
              ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: 550,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                          child: _getCharacterView(
                              leftCharacter, true, line?.characterId == leftCharacter?.character?.id)),
                    ),
                    SizedBox(
                      width: 1000,
                      child: Align(
                        alignment: textAlign == TextAlign.left
                            ? Alignment.centerLeft
                            : textAlign == TextAlign.right
                                ? Alignment.centerRight
                                : Alignment.center,
                        child: _getAnimatedDialogText(textAlign, false),
                      ),
                    ),
                    Expanded(
                      child:
                          _getCharacterView(rightCharacter, false, line?.characterId == rightCharacter?.character?.id),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAnimatedDialogText(TextAlign textAlign, bool isTall) {
    var w = Hero(
      tag: "textBox",
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(colors: [Colors.blue, Colors.blue.shade600]),
              boxShadow: const [BoxShadow(blurRadius: 20, offset: Offset(10, 10), color: Colors.black54)]),
          child: SingleChildScrollView(
            child: TextAnimator(
              widget.controller.currentLine?.text ?? '',
              textAlign: textAlign,
              style: GoogleFonts.comicNeue(fontSize: isTall ? 20 : 36),
              characterDelay: const Duration(milliseconds: 5),
              spaceDelay: Duration.zero,
              atRestEffect: WidgetRestingEffects.wave(effectStrength: .10),
            ),
          )),
    );
    if (isTall) {
      return Align(
        alignment: textAlign == TextAlign.left
            ? Alignment.topLeft
            : textAlign == TextAlign.right
                ? Alignment.bottomRight
                : Alignment.center,
        child: w,
      );
    }
    return w;
  }

  Widget _getCharacterView(_DisplayCharacter? character, bool left, bool focused) {
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
        WidgetAnimator(
            key: ValueKey("${character.character?.id}"),
            incomingEffect: !focused
                ? null
                : left
                    ? WidgetTransitionEffects.incomingSlideInFromLeft()
                    : WidgetTransitionEffects.incomingSlideInFromRight(),
            outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToLeft(),
            atRestEffect: WidgetRestingEffects.fidget(
              effectStrength: focused ? 1 : .01,
              duration: const Duration(milliseconds: 10000),
            ),
            child: SizedBox(width: 320, height: 320, child: imageUrl.isEmpty ? Container() : Image.network(imageUrl))),
        Text(
          character.characterName.isNotEmpty ? character.characterName : character.character?.name ?? '',
          style: GoogleFonts.comicNeue(fontSize: 36),
        )
      ],
    ).animate(target: focused ? 1 : 0).scaleXY(end: 1.1);
  }
}

class _DisplayCharacter {
  Character? character;
  String characterName;
  CharacterPicture? characterPic;

  _DisplayCharacter(this.character, this.characterName, this.characterPic);
}

class ConversationViewerController {
  late Conversation conversation;
  late List<Character> characters;
  List<ConversationLine>? lines;

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

  ConversationViewerController(this.conversation, this.characters) {
    lines = conversation.lines.orderBy((element) => element.sortOrder).toList();
  }
}
