import 'package:dialog_utility/models/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareConversationDialog extends StatefulWidget {
  const ShareConversationDialog({required this.conversation, required this.projectId, super.key});
  final String projectId;
  final Conversation conversation;

  @override
  State<ShareConversationDialog> createState() => _ShareConversationDialogState();
}

class _ShareConversationDialogState extends State<ShareConversationDialog> {
  String get _link => "https://dialog-manager-9f243.web.app/view?p=${widget.projectId}&c=${widget.conversation.id}";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Share Conversation"),
      content: TextFormField(
        initialValue: _link,
        enabled: false,
      ),
      actions: [
        TextButton(onPressed: () => Clipboard.setData(ClipboardData(text: _link)), child: const Text("Copy")),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
      ],
    );
  }
}
