import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/dialogs/character_picture_dialog.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/character_picture.dart';
import 'package:dialog_utility/models/project.dart';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CharacterDetailPage extends StatefulWidget {
  const CharacterDetailPage(this.project, this.character, {super.key});
  final Project project;
  final Character character;

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  final _form = GlobalKey<FormState>();
  late Character _character;

  @override
  void initState() {
    _character = widget.character;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                width: 300,
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(label: Text("Short Name")),
                    initialValue: _character.handle,
                    onChanged: (value) async {
                      _character.handle = value;
                      await writeCharacter();
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(label: Text("Name")),
                    initialValue: _character.name,
                    onChanged: (value) {
                      _character.name = value;
                      writeCharacter();
                    },
                  ),
                ]),
              ),
            ),
            Expanded(
              child: DropRegion(
                  formats: const [Formats.png, Formats.jpeg, Formats.svg],
                  onDropOver: (event) => DropOperation.copy,
                  onPerformDrop: (event) async {
                    final item = event.session.items.first;

                    final reader = item.dataReader!;
                    if (reader.canProvide(Formats.png)) {
                      reader.getFile(Formats.png, (file) async {
                        var fileStream = file.getStream();
                        var bytes = await fileStream.first;
                        // upload image to Firebase Storage
                        Reference storageRef =
                            FirebaseStorage.instance.ref().child('characterPictures/${uuid.v4()}.png');
                        UploadTask uploadTask = storageRef.putData(bytes, SettableMetadata(contentType: "image/png"));
                        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

                        // get image URL
                        String imageUrl = await snapshot.ref.getDownloadURL();

                        var pic = CharacterPicture(id: uuid.v4(), imageUrl: imageUrl, description: '');

                        _character.pictures.add(pic);

                        await widget.project.charactersRef.doc(_character.id).set(_character.toJson());
                      });
                    }
                  },
                  child: Builder(builder: (context) {
                    var pics = _character.pictures;
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
                      itemCount: pics.length,
                      itemBuilder: (context, index) {
                        var pic = pics[index];
                        return Card(
                          child: InkWell(
                            onTap: () => _showCharacterPictureDialog(pic),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Image.network(pic.imageUrl),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: IconButton(
                                              onPressed: () {
                                                _character.defaultPictureId = pic.id;
                                                writeCharacter();
                                              },
                                              icon: Icon(
                                                _character.defaultPictureId == pic.id ? Icons.star : Icons.star_border,
                                                color: Colors.yellow,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    pic.description,
                                    softWrap: false,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }

  Future writeCharacter() async {
    try {
      await widget.project.charactersRef.doc(_character.id).set(_character.toJson());
    } catch (ex) {
      print(ex);
    }
  }

  _showCharacterPictureDialog(CharacterPicture picture) async {
    var result = await showDialog<CharacterPicture>(
      context: context,
      builder: (context) => CharacterPictureDialog(picture),
    );
    if (result != null) {
      if (picture.id == 'delete') {
        widget.character.pictures.remove(picture);
      }
      await writeCharacter();
    }
  }
}
