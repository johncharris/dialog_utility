import 'package:dialog_utility/models/conversation_line.dart';

import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

@JsonSerializable(explicitToJson: true)
class Conversation {
  String? id;
  String name;

  List<ConversationLine> lines;

  String backgroundUrl;

  String textAreaBackgroundColor;

  Conversation(
      {required this.name, required this.lines, this.backgroundUrl = '', this.textAreaBackgroundColor = "#00000000"});

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
