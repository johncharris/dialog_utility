import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser {
  String id;
  String name;
  List<String> projectIds = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  late CollectionReference conversationsRef;

  AppUser({required this.id, required this.name});

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
