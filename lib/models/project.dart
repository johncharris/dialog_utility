import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable(explicitToJson: true)
class Project {
  String id;
  String name;
  String imageUrl;
  String description;
  String ownerId;
  List<String> readerUserIds = [];
  List<String> editorUserIds = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  late CollectionReference conversationsRef;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late CollectionReference charactersRef;

  Project(
      {required this.id, required this.ownerId, required this.name, required this.imageUrl, required this.description});

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
