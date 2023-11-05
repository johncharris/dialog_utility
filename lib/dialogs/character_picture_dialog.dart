import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/character_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class CharacterPictureDialog extends StatefulWidget {
  const CharacterPictureDialog(this.picture, {super.key});
  final CharacterPicture picture;

  @override
  State<CharacterPictureDialog> createState() => _CharacterPictureDialogState();
}

class _CharacterPictureDialogState extends State<CharacterPictureDialog> {
  final _formKey = GlobalKey<FormState>();

  late String url;

  @override
  void initState() {
    url = widget.picture.imageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FormField<String>(
        initialValue: widget.picture.imageUrl,
        onSaved: (newValue) => widget.picture.imageUrl = newValue ?? '',
        builder: (field) => AlertDialog(
          title: const Text("Character Picture"),
          content: DropRegion(
              formats: const [Formats.png, Formats.jpeg, Formats.svg],
              onDropOver: (event) => DropOperation.copy,
              onPerformDrop: (event) async {
                final item = event.session.items.first;

                final reader = item.dataReader!;
                if (reader.canProvide(Formats.png)) {
                  reader.getFile(Formats.png, (file) async {
                    var fileStream = file.readAll();
                    var bytes = await fileStream;
                    // upload image to Firebase Storage
                    Reference storageRef = FirebaseStorage.instance.ref().child('characterPictures/${uuid.v4()}.png');
                    UploadTask uploadTask = storageRef.putData(bytes, SettableMetadata(contentType: "image/png"));
                    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

                    // get image URL
                    var u = await snapshot.ref.getDownloadURL();
                    field.didChange(u);
                    setState(() {
                      url = u;
                    });

                    // var pic = CharacterPicture(id: uuid.v4(), imageUrl: imageUrl, description: '');

                    // _character.pictures.add(pic);

                    // await widget.project.charactersRef.doc(_character.id).set(_character.toJson());
                  });
                }
              },
              child: Builder(
                builder: (context) {
                  var pic = widget.picture;
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Image.network(url),
                        ),
                        TextFormField(
                          initialValue: pic.description,
                          onSaved: (newValue) => pic.description = newValue!,
                          decoration: const InputDecoration(labelText: "Description"),
                        )
                      ],
                    ),
                  );
                },
              )),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.picture.id = "delete";
                  Navigator.of(context).pop(widget.picture);
                }
              },
              child: const Text("Delete Picture", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.of(context).pop(widget.picture);
                }
              },
              child: const Text("Save Picture"),
            ),
          ],
        ),
      ),
    );
  }
}
