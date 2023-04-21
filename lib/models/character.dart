// import 'package:dialog_utility/models/character_pic.dart';
import 'package:isar/isar.dart';

import 'character_pic.dart';

part 'character.g.dart';

@Collection()
class Character {
  Id? id;

  @Index(caseSensitive: false)
  late String name;

  late String handle;

  @Backlink(to: 'character')
  final pics = IsarLinks<CharacterPic>();

  Character(this.name, this.handle);
}
