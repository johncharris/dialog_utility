import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/models/conversation_line.dart';

import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

@JsonSerializable(explicitToJson: true)
class Conversation {
  String? id;
  String name;

  List<ConversationLine> lines;

  Conversation({required this.name, required this.lines});

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
