// import 'package:dialog_utility/db_manager.dart';
// import 'package:dialog_utility/models/conversation.dart';
// import 'package:dialog_utility/pages/conversation_detail_page.dart';
// import 'package:dialog_utility/widgets/conversation_viewer.dart';
// import 'package:flutter/material.dart';

// class ConversationViewerPage extends StatefulWidget {
//   const ConversationViewerPage({super.key});

//   @override
//   State<ConversationViewerPage> createState() => _ConversationViewerPageState();
// }

// class _ConversationViewerPageState extends State<ConversationViewerPage> {
//   int? _selectedKey;
//   ConversationViewerController? _viewerController;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: DbManager.instance.isar.conversations.where().watch(initialReturn: true),
//         builder: (context, value) => Builder(builder: (context) {
//               var conversations = value.hasData ? value.data! : <Conversation>[];
//               return Row(
//                 children: [
//                   SizedBox(
//                     width: 300,
//                     child: Scaffold(
//                       body: ListView.builder(
//                         itemCount: conversations.length,
//                         itemBuilder: (context, index) {
//                           var conversation = conversations[index];
//                           return ListTile(
//                             onTap: () {
//                               setState(() => _selectedKey = conversation.id);
//                               _viewerController = ConversationViewerController(conversation.id!);
//                             },
//                             selected: _selectedKey == conversation.id,
//                             title: Text(conversation.name),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   if (_selectedKey != null && _viewerController != null)
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => _viewerController!.next(),
//                         child: ConversationViewer(
//                           controller: _viewerController!,
//                           key: ValueKey(_selectedKey),
//                         ),
//                       ),
//                     )
//                 ],
//               );
//             }));
//   }
// }
