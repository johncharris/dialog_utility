import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/character_pic.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/conversation_line.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DbManager {
  static DbManager instance = DbManager();

  late Isar _isar;
  Isar get isar => _isar;

  init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([CharacterSchema, CharacterPicSchema, ConversationSchema, ConversationLineSchema],
          directory: dir.path);
    } catch (ex) {
      print(ex);
    }
  }
}
