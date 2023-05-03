import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/widgets/conversation_viewer.dart';
import 'package:flutter/material.dart';

class ConversationViewerPage extends StatefulWidget {
  const ConversationViewerPage({super.key});

  @override
  State<ConversationViewerPage> createState() => _ConversationViewerPageState();
}

class _ConversationViewerPageState extends State<ConversationViewerPage> {
  String? _selectedKey;
  ConversationViewerController? _viewerController;

  CollectionReference conversationsRef = FirebaseFirestore.instance.collection('conversations');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: conversationsRef.snapshots(),
        builder: (context, value) => Builder(builder: (context) {
              var conversations = value.hasData
                  ? value.data!.docs
                      .map((e) => Conversation.fromJson(e.data() as Map<String, dynamic>)..id = e.id)
                      .toList()
                  : <Conversation>[];
              return Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Scaffold(
                      body: ListView.builder(
                        itemCount: conversations.length,
                        itemBuilder: (context, index) {
                          var conversation = conversations[index];
                          return ListTile(
                            onTap: () {
                              setState(() => _selectedKey = conversation.id);
                              _viewerController = ConversationViewerController(conversation.id!);
                            },
                            selected: _selectedKey == conversation.id,
                            title: Text(conversation.name),
                          );
                        },
                      ),
                    ),
                  ),
                  if (_selectedKey != null && _viewerController != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _viewerController!.next(),
                        child: ConversationViewer(
                          controller: _viewerController!,
                          key: ValueKey(_selectedKey),
                        ),
                      ),
                    )
                ],
              );
            }));
  }
}
