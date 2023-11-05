import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/utils/share_util.dart';
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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Share Conversation"),
      content: TextFormField(
        initialValue: getShareLink(widget.conversation),
        enabled: false,
      ),
      actions: [
        TextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: getShareLink(widget.conversation))),
            child: const Text("Copy")),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
      ],
    );
  }
}
