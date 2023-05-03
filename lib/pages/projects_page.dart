import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/models/app_user.dart';
import 'package:dialog_utility/models/project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference projectsRef = FirebaseFirestore.instance.collection('projects');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
        actions: [
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: StreamBuilder(
        stream: userRef.doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(
              child: Text("Loading"),
            );
          }
          var user = AppUser.fromJson(userSnapshot.data!.data() as dynamic)..id = userSnapshot.data!.id;

          return StreamBuilder(
            stream: projectsRef.where(FieldPath.documentId, whereIn: user.projectIds).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("Loading"),
                );
              }
              final projects = snapshot.data!.docs.map((e) => Project.fromJson(e.data() as dynamic)).toList();
              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  var project = projects[index];
                  ListTile(
                    title: Text(project.name),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
