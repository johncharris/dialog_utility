import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'character_pic.g.dart';

@HiveType(typeId: 1)
class CharacterPic extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  Uint8List bytes;

  CharacterPic(this.name, this.bytes);
}
