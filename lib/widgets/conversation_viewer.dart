import 'dart:async';

import 'package:darq/darq.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/character_picture.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/conversation_line.dart';
import 'package:dialog_utility/models/enums.dart';
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

  final TextAlign _lastAlign = TextAlign.center;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.controller.indexStream,
        builder: (context, snapshot) {
          var line = widget.controller.currentLine;

          var left = widget.controller.characters.firstWhereOrDefault((c) => c.id == line!.leftCharacterId);
          if (left == null) {
            leftCharacter = null;
          } else {
            leftCharacter = _DisplayCharacter(
                left,
                line!.leftCharacterName ?? '',
                left.pictures.firstWhereOrDefault(
                    (value) => value.id == (line.leftCharacterPicId ?? left.defaultPictureId ?? '')));
          }

          var right = widget.controller.characters.firstWhereOrDefault((c) => c.id == line!.rightCharacterId);
          if (right == null) {
            rightCharacter = null;
          } else {
            rightCharacter = _DisplayCharacter(
                right,
                line!.rightCharacterName ?? '',
                right.pictures.firstWhereOrDefault(
                    (value) => value.id == (line.rightCharacterPicId ?? right.defaultPictureId ?? '')));
          }

          var speaker = line!.speakerPosition == CharacterPosition.left
              ? left
              : line.speakerPosition == CharacterPosition.right
                  ? right
                  : null;

          return Builder(
            builder: (context) {
              final mq = MediaQuery.of(context);
              bool isTall = mq.size.height > mq.size.width;
              return isTall ? _getTallLayout(line, speaker) : _getWideLayout(line, speaker);
            },
          );
        });
  }

  Widget _getTallLayout(ConversationLine? line, Character? speaker) {
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
                    child:
                        _getCharacterView(leftCharacter, true, line?.leftCharacterId == leftCharacter?.character?.id),
                  )),
                )),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: _getAnimatedDialogText(line!.speakerPosition, true, speaker))),
                Expanded(
                    child: SizedBox.expand(
                        child: FittedBox(
                            child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      _getCharacterView(rightCharacter, false, line.leftCharacterId == rightCharacter?.character?.id),
                ))))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getWideLayout(ConversationLine? line, Character? speaker) {
    TextAlign textAlign = line!.speakerPosition == CharacterPosition.left
        ? TextAlign.left
        : line.speakerPosition == CharacterPosition.right
            ? TextAlign.right
            : TextAlign.center;

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
                              leftCharacter, true, line.leftCharacterId == leftCharacter?.character?.id)),
                    ),
                    SizedBox(
                      width: 1000,
                      child: Align(
                        alignment: textAlign == TextAlign.left
                            ? Alignment.centerLeft
                            : textAlign == TextAlign.right
                                ? Alignment.centerRight
                                : Alignment.center,
                        child: _getAnimatedDialogText(line.speakerPosition, false, speaker),
                      ),
                    ),
                    Expanded(
                      child: _getCharacterView(
                          rightCharacter, false, line.leftCharacterId == rightCharacter?.character?.id),
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

  Widget _getAnimatedDialogText(CharacterPosition speakerPosition, bool isTall, Character? speaker) {
    TextAlign textAlign = speakerPosition == CharacterPosition.left
        ? TextAlign.left
        : speakerPosition == CharacterPosition.right
            ? TextAlign.right
            : TextAlign.center;
    var w = Hero(
      tag: "textBox",
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(speaker?.color ?? Colors.blue.value),
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
  VoidCallback? onFinished;

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
    if (lines == null || index >= lines!.length - 1) return null;
    return lines![index + 1];
  }

  bool next() {
    if (nextLine == null) {
      onFinished?.call();
      return false;
    }

    index++;
    indexStreamController.add(index);
    return true;
  }

  ConversationViewerController(this.conversation, this.characters, {this.onFinished}) {
    lines = conversation.lines.orderBy((element) => element.sortOrder).toList();
  }
}
