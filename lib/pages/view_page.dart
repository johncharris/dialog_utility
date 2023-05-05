import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:meta_seo/meta_seo.dart';

import '../widgets/conversation_viewer.dart';

class ViewPage extends StatefulWidget {
  const ViewPage(this.projectId, this.conversationId, {super.key});
  final String projectId;
  final String conversationId;

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  ConversationViewerController? _viewerController;
  String? _selectedKey;
  Conversation? _conversation;
  List<Character>? _characters;

  @override
  void initState() {
    _load();

    super.initState();
  }

  _load() async {
    _conversation = Conversation.fromJson((await FirebaseFirestore.instance
            .doc("projects/${widget.projectId}/conversations/${widget.conversationId}")
            .get())
        .data()!);
    _characters = (await FirebaseFirestore.instance.collection("projects/${widget.projectId}/characters").get())
        .docs
        .map((e) => Character.fromJson(e.data()))
        .toList();

    var seo = MetaSEO();
    seo.ogTitle(ogTitle: _conversation!.name);
    seo.ogImage(ogImage: _characters!.first.pictures.first.imageUrl);

    setState(() {
      _viewerController = ConversationViewerController(_conversation!, _characters!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        if (_viewerController == null) return const Center(child: Loading());
        return Column(
          children: [
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => _viewerController!.next(),
                  child: ConversationViewer(
                    controller: _viewerController!,
                    key: ValueKey(_selectedKey),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
