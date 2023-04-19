import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/models/conversation_line.dart';
import 'package:hive/hive.dart';

part 'conversation.g.dart';

@HiveType(typeId: 2)
class Conversation extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList<ConversationLine> lines;

  Conversation(this.name, {HiveList<ConversationLine>? lines})
      : lines = lines ?? HiveList<ConversationLine>(DbManager.instance.conversationLines);
}
