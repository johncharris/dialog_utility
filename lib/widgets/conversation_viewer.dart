// import 'dart:async';
// import 'dart:typed_data';

// import 'package:darq/darq.dart';
// import 'package:dialog_utility/db_manager.dart';
// import 'package:dialog_utility/models/character.dart';
// import 'package:dialog_utility/models/character_picture.dart';
// import 'package:dialog_utility/models/conversation.dart';
// import 'package:dialog_utility/models/conversation_line.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ConversationViewer extends StatefulWidget {
//   const ConversationViewer({required this.controller, super.key});
//   final ConversationViewerController controller;

//   @override
//   State<ConversationViewer> createState() => _ConversationViewerState();
// }

// class _ConversationViewerState extends State<ConversationViewer> {
//   Conversation? conversation;

//   _DisplayCharacter? leftCharacter;
//   _DisplayCharacter? rightCharacter;

//   TextAlign _lastAlign = TextAlign.center;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<int>(
//         stream: widget.controller.indexStream,
//         builder: (context, snapshot) {
//           var textAlign = TextAlign.center;

//           var line = widget.controller.currentLine;
//           if (line?.character.value != null) {
// // assign the character based on left or right being availible
//             if (leftCharacter?.character?.id == line!.character.value?.id) {
//               textAlign = TextAlign.left;
//             } else if (rightCharacter?.character?.id == line.character.value?.id) {
//               textAlign = TextAlign.right;
//             } else {
//               // No existing character was found we need to add one.
//               if (_lastAlign != TextAlign.left) {
//                 leftCharacter =
//                     _DisplayCharacter(line.character.value, line.characterName ?? '', line.characterPic.value);
//                 textAlign = TextAlign.left;
//                 _lastAlign = TextAlign.left;
//               } else {
//                 rightCharacter =
//                     _DisplayCharacter(line.character.value, line.characterName ?? '', line.characterPic.value);
//                 textAlign = TextAlign.right;
//                 _lastAlign = TextAlign.right;
//               }
//             }
//           }

//           return FittedBox(
//             fit: BoxFit.contain,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(border: Border.all(color: Colors.accents.first, width: 1)),
//                 width: 1920,
//                 height: 1080,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Center(
//                           child: _getCharacterView(
//                               leftCharacter, line?.character.value?.id == leftCharacter?.character?.id)),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         widget.controller.currentLine?.text ?? '',
//                         textAlign: textAlign,
//                         style: GoogleFonts.comicNeue(fontSize: 36),
//                       ),
//                     ),
//                     Expanded(
//                       child:
//                           _getCharacterView(rightCharacter, line?.character.value?.id == rightCharacter?.character?.id),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   Widget _getCharacterView(_DisplayCharacter? character, bool focused) {
//     if (character == null) return Container();

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (character.character?.defaultPicId != null)
//           SizedBox(
//             width: 320,
//             height: 320,
//             child: FutureBuilder(
//                 key: ValueKey("ProfilePic${character.character!.defaultPicId!}"),
//                 future: DbManager.instance.isar.characterPics.get(character.character!.defaultPicId!),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) return Container();
//                   return Image.memory(
//                     snapshot.data!.bytes,
//                   );
//                 }),
//           ),
//         Text(
//           character.characterName.isNotEmpty ? character.characterName : character.character?.name ?? '',
//           style: GoogleFonts.comicNeue(fontSize: 36),
//         )
//       ],
//     ).animate(target: focused ? 1 : 0).scaleXY(end: 1.1).fade(begin: .8, end: 1);
//   }
// }

// class _DisplayCharacter {
//   Character? character;
//   String characterName;
//   CharacterPic? characterPic;

//   _DisplayCharacter(this.character, this.characterName, this.characterPic);
// }

// class ConversationViewerController {
//   final int conversationId;

//   Conversation? conversation;
//   List<ConversationLine>? lines;

//   final indexStreamController = StreamController<int>.broadcast();
//   Stream<int> get indexStream => indexStreamController.stream;

//   int index = 0;

//   ConversationLine? get previousLine {
//     if (lines == null || index == 0) return null;
//     return lines![index - 1];
//   }

//   ConversationLine? get currentLine {
//     if (lines == null) return null;
//     if (lines!.length < index) return null;
//     return lines![index];
//   }

//   ConversationLine? get nextLine {
//     if (lines == null || index >= lines!.length + 1) return null;
//     return lines![index + 1];
//   }

//   bool next() {
//     if (nextLine == null) return false;

//     index++;
//     indexStreamController.add(index);
//     return true;
//   }

//   ConversationViewerController(this.conversationId) {
//     _loadConversation();
//   }

//   Future _loadConversation() async {
//     conversation = await DbManager.instance.isar.conversations.get(conversationId);
//     if (conversation == null) return;

//     await conversation!.lines.load();
//     for (var line in conversation!.lines) {
//       await line.character.load();
//       await line.characterPic.load();
//     }

//     lines = conversation!.lines
//         .toList()
//         .orderBy(
//           (element) => element.sortOrder,
//         )
//         .toList();

//     index = 0;
//     indexStreamController.add(index);
//   }
// }
