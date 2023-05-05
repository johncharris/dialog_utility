import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/project.dart';
import 'package:dialog_utility/widgets/conversation_viewer.dart';
import 'package:flutter/material.dart';

import '../models/character.dart';

class ConversationViewerPage extends StatefulWidget {
  const ConversationViewerPage(this.project, {super.key});
  final Project project;

  @override
  State<ConversationViewerPage> createState() => _ConversationViewerPageState();
}

class _ConversationViewerPageState extends State<ConversationViewerPage> {
  String? _selectedKey;
  ConversationViewerController? _viewerController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.project.conversationsRef.snapshots(),
        builder: (context, value) => StreamBuilder(
            stream: widget.project.charactersRef.snapshots(),
            builder: (context, charactersSnapshot) {
              var conversations = value.hasData
                  ? value.data!.docs
                      .map((e) => Conversation.fromJson(e.data() as Map<String, dynamic>)..id = e.id)
                      .toList()
                  : <Conversation>[];
              var characters = charactersSnapshot.hasData
                  ? charactersSnapshot.data!.docs
                      .map((e) => Character.fromJson(e.data() as dynamic)..id = e.id)
                      .toList()
                  : <Character>[];
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
                              _viewerController = ConversationViewerController(conversation, characters);
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
