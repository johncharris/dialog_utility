import 'package:dialog_utility/models/conversation_line.dart';
import 'package:isar/isar.dart';

part 'conversation.g.dart';

@Collection()
class Conversation {
  Id? id;
  String name;

  @Backlink(to: 'conversation')
  final lines = IsarLinks<ConversationLine>();

  Conversation(this.name);
}
