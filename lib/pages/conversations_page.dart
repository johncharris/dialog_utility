import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/project.dart';
import 'package:dialog_utility/pages/conversation_detail_page.dart';
import 'package:flutter/material.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage(this.project, {super.key});
  final Project project;

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  String? _selectedKey;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.project.conversationsRef.snapshots(),
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
                      floatingActionButton: FloatingActionButton(
                          onPressed: () async {
                            var ref = await widget.project.conversationsRef
                                .add(Conversation(name: "Nameless", lines: []).toJson());
                          },
                          child: const Icon(Icons.add)),
                      body: ListView.builder(
                        itemCount: conversations.length,
                        itemBuilder: (context, index) {
                          var conversation = conversations[index];
                          return ListTile(
                            onTap: () => setState(() => _selectedKey = conversation.id),
                            selected: _selectedKey == conversation.id,
                            title: Text(conversation.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _showDeleteDialog(conversation),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (_selectedKey != null)
                    Expanded(
                      child: ConversationDetailPage(
                        widget.project,
                        _selectedKey!,
                        key: ValueKey(_selectedKey),
                      ),
                    )
                ],
              );
            }));
  }

  _showDeleteDialog(Conversation conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Conversation"),
        content: Text("Are you sure you want to delete ${conversation.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Don't Delete")),
          TextButton(onPressed: () => _deleteConversation(conversation), child: Text("Delete ${conversation.name}"))
        ],
      ),
    );
  }

  _deleteConversation(Conversation conversation) async {
    await widget.project.conversationsRef.doc(conversation.id).delete();

    if (!mounted) return;

    Navigator.pop(context);
  }
}
