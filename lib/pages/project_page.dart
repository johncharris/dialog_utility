import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/models/project.dart';
import 'package:dialog_utility/pages/characters_page.dart';
import 'package:dialog_utility/pages/conversation_viewer_page.dart';
import 'package:dialog_utility/pages/conversations_page.dart';
import 'package:dialog_utility/providers/selected_project_provider.dart';
import 'package:dialog_utility/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage(this.projectId, {super.key});
  final String projectId;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int _selectedIndex = 0;

  late DocumentReference projectRef;

  @override
  initState() {
    super.initState();
    selectedProjectId = widget.projectId;
    projectRef = FirebaseFirestore.instance.collection("projects").doc(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dialog Manager"),
        actions: [
          IconButton(onPressed: () => AdaptiveTheme.of(context).toggleThemeMode(), icon: const Icon(Icons.light_mode)),
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: FutureBuilder(
        future: projectRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Loading();

          final project = Project.fromJson(snapshot.data!.data() as dynamic)..id = snapshot.data!.id;
          project.conversationsRef = snapshot.data!.reference.collection("conversations");
          project.charactersRef = snapshot.data!.reference.collection("characters");
          return Row(
            children: [
              NavigationRail(
                  onDestinationSelected: (value) => setState(() => _selectedIndex = value),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.people), label: Text("Characters")),
                    NavigationRailDestination(icon: Icon(Icons.chat), label: Text("Conversations")),
                    NavigationRailDestination(icon: Icon(Icons.play_arrow), label: Text("Preview")),
                    // NavigationRailDestination(icon: Icon(Icons.import_export), label: Text("Export"))
                  ],
                  selectedIndex: _selectedIndex),
              const VerticalDivider(
                thickness: 1,
                width: 1,
              ),
              if (_selectedIndex == 0) Expanded(child: CharactersPage(project)),
              if (_selectedIndex == 1) Expanded(child: ConversationsPage(project)),
              if (_selectedIndex == 2) Expanded(child: ConversationViewerPage(project)),
              // if (_selectedIndex == 3) const Expanded(child: ExportPage()),
            ],
          );
        },
      ),
    );
  }
}
