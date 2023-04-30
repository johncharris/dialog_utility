// import 'package:dialog_utility/db_manager.dart';
// import 'package:dialog_utility/models/conversation.dart';
// import 'package:file_selector/file_selector.dart';
// import 'package:flutter/material.dart';

// class ExportPage extends StatefulWidget {
//   const ExportPage({super.key});

//   @override
//   State<ExportPage> createState() => _ExportPageState();
// }

// class _ExportPageState extends State<ExportPage> {
//   final TextEditingController _pathController = TextEditingController();
//   String path = '';
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _pathController,
//                 ),
//               ),
//               IconButton(onPressed: () => _selectFolder(), icon: const Icon(Icons.folder))
//             ],
//           ),
//           ElevatedButton(onPressed: () => _export(), child: const Text("Export"))
//         ],
//       ),
//     );
//   }

//   _selectFolder() async {
//     var directory = await getDirectoryPath();
//     if (directory != null) {
//       path = directory;
//       _pathController.text = directory;
//     }
//   }

//   _export() async {
//     if (path.isNotEmpty) {
//       var conversations = await DbManager.instance.isar.conversations.where().findAll();
//     }
//   }
// }
