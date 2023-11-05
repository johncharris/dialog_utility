import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/utils/share_util.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class StoryEndDialog extends StatefulWidget {
  const StoryEndDialog(this.conversation, {super.key});
  final Conversation conversation;

  @override
  State<StoryEndDialog> createState() => _StoryEndDialogState();
}

class _StoryEndDialogState extends State<StoryEndDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("The End"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("We hope you enjoyed reading:"),
          Text(
            widget.conversation.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [],
          )
        ],
      ),
      actions: [
        TextButton.icon(
            onPressed: () => Navigator.pop(context, "restart"),
            icon: const Icon(Icons.replay),
            label: const Text("Play Again")),
        TextButton.icon(
            onPressed: () =>
                Share.share("Check out: ${widget.conversation.name}. ${getShareLink(widget.conversation)}"),
            icon: const Icon(Icons.share),
            label: const Text("Share")),
      ],
    );
  }
}
