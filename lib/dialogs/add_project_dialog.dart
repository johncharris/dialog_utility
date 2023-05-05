import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/models/project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  String projectName = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Project"),
      content: TextField(
        decoration: const InputDecoration(labelText: "Project Name"),
        onChanged: (value) => projectName = value,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        TextButton(onPressed: () => _addProject(), child: const Text("Add Project"))
      ],
    );
  }

  _addProject() async {
    // Create the project
    var ref = await FirebaseFirestore.instance.collection("projects").add(Project(
            id: '', ownerId: FirebaseAuth.instance.currentUser!.uid, name: projectName, imageUrl: '', description: '')
        .toJson());

    // add the project to the user
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      "projectIds": FieldValue.arrayUnion([ref.id])
    });

    if (!context.mounted) return;

    Navigator.pop(context);
  }
}
