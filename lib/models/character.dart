import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/character_pic.dart';
import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String handle;

  @HiveField(2)
  HiveList<CharacterPic> pics;

  Character(this.name, this.handle, {HiveList<CharacterPic>? pics})
      : pics = pics ?? HiveList<CharacterPic>(DbManager.instance.characterPics);
}
