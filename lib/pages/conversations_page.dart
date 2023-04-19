import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/pages/conversation_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  int? _selectedKey;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: DbManager.instance.conversations.listenable(),
        builder: (context, value, child) => Builder(builder: (context) {
              return Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Scaffold(
                      floatingActionButton: FloatingActionButton(
                          onPressed: () async {
                            await value.add(Conversation("Nameless"));
                          },
                          child: const Icon(Icons.add)),
                      body: ListView.builder(
                        itemCount: value.keys.length,
                        itemBuilder: (context, index) {
                          var key = value.keyAt(index);
                          var conversation = value.getAt(index);
                          return ListTile(
                            onTap: () => setState(() => _selectedKey = key),
                            selected: _selectedKey == key,
                            title: Text(conversation!.name),
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
    await conversation.delete();

    if (!mounted) return;

    Navigator.pop(context);
  }
}
