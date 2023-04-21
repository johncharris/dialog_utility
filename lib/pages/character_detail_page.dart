import 'dart:typed_data';

import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/character_pic.dart';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class CharacterDetailPage extends StatefulWidget {
  const CharacterDetailPage(this.character, {super.key});
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
                        var bytes = await file.readAll();

                        var pic = CharacterPic(file.fileName ?? '', bytes);

                        _character.pics.add(pic);
                        await DbManager.instance.isar.writeTxn(() async {
                          await DbManager.instance.isar.characterPics.put(pic);
                          await DbManager.instance.isar.characters.put(_character);
                          await _character.pics.save();
                        });
                      });
                    }
                  },
                  child: FutureBuilder(
                      future: _character.pics.load(),
                      builder: (context, snapshot) {
                        var pics = _character.pics.toList();
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
                          itemCount: pics.length,
                          itemBuilder: (context, index) {
                            var pic = pics[index];
                            return Card(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.memory(Uint8List.fromList(pic.bytes)),
                                    Text(
                                      pic.name,
                                      softWrap: false,
                                    )
                                  ],
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
    await DbManager.instance.isar.writeTxn(() async => await DbManager.instance.isar.characters.put(_character));
  }
}
