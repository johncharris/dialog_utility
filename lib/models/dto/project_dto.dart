import 'package:dialog_utility/models/character.dart';
import 'package:dialog_utility/models/conversation.dart';
import 'package:dialog_utility/models/project.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectDto {
  String id;
  String name;
  String imageUrl;
  String description;

  List<Conversation> conversations = [];
  List<Character> characters = [];

  ProjectDto({required this.id, required this.name, required this.imageUrl, required this.description});

  factory ProjectDto.fromProject(Project project, List<Character> characters, List<Conversation> conversations) {
    var dto =
        ProjectDto(description: project.description, id: project.id, imageUrl: project.imageUrl, name: project.name);
    dto.characters = characters;
    dto.conversations = conversations;
    return dto;
  }

  factory ProjectDto.fromJson(Map<String, dynamic> json) => _$ProjectDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectDtoToJson(this);
}
