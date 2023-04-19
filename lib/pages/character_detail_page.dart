import 'dart:typed_data';

import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/character_pic.dart';
import 'package:flutter/material.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class CharacterDetailPage extends StatefulWidget {
  const CharacterDetailPage(this.id, {super.key});
  final int id;

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  final _form = GlobalKey<FormState>();
  late Character _character;

  @override
  void initState() {
    _character = DbManager.instance.characters.getAt(widget.id)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Expanded(
        child: Row(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                width: 300,
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(label: Text("Short Name")),
                    initialValue: _character.handle,
                    onChanged: (value) {
                      _character.handle = value;
                      DbManager.instance.characters.put(widget.id, _character);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(label: Text("Name")),
                    initialValue: _character.name,
                    onChanged: (value) {
                      _character.name = value;
                      DbManager.instance.characters.put(widget.id, _character);
                    },
                  ),
                ]),
              ),
            ),
            Expanded(
              child: Stack(children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
                    itemCount: _character.pics.length,
                    itemBuilder: (context, index) {
                      var pic = _character.pics[index];
                      return Card(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.memory(pic.bytes),
                              Text(
                                pic.name,
                                softWrap: false,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: DropRegion(
                      formats: const [Formats.png, Formats.jpeg, Formats.svg],
                      onDropOver: (event) => DropOperation.copy,
                      onPerformDrop: (event) async {
                        final item = event.session.items.first;

                        final reader = item.dataReader!;
                        if (reader.canProvide(Formats.png)) {
                          reader.getFile(Formats.png, (file) async {
                            var bytes = await file.readAll();

                            // Add the file to the box
                            var pic = CharacterPic(file.fileName ?? '', bytes);
                            await DbManager.instance.characterPics.add(pic);
                            _character.pics.add(pic);
                            await _character.save();
                          });
                        }
                      },
                      child: const Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text('Drop items here'),
                        ),
                      )),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
