import 'package:dialog_utility/models/character.dart';
import 'package:isar/isar.dart';

part 'character_pic.g.dart';

@Collection()
class CharacterPic {
  Id? id;
  late String name;

  late List<byte> bytes;

  final character = IsarLink<Character>();

  CharacterPic(this.name, this.bytes);
}
