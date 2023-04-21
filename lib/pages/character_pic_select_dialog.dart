// import 'package:dialog_utility/models/conversation_line.dart';
// import 'package:flutter/material.dart';

// class CharacterPicSelectDialog extends StatefulWidget {
//   const CharacterPicSelectDialog(this.conversationLine, {super.key});
//   final ConversationLine conversationLine;
//   @override
//   State<CharacterPicSelectDialog> createState() => _CharacterPicSelectDialogState();
// }

// class _CharacterPicSelectDialogState extends State<CharacterPicSelectDialog> {
//   @override
//   Widget build(BuildContext context) {
//     final character = widget.conversationLine.character!;
//     var pics = character.pics.toList();
//     return AlertDialog(
//       title: const Text("Select Pic"),
//       content: SizedBox(
//         width: 800,
//         height: 500,
//         child: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
//           itemCount: pics.length,
//           itemBuilder: (context, index) {
//             Image.memory(pics[index].bytes);
//           },
//         ),
//       ),
//       actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"))],
//     );
//   }
// }
