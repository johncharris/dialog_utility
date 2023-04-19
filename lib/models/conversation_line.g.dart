// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_line.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationLineAdapter extends TypeAdapter<ConversationLine> {
  @override
  final int typeId = 3;

  @override
  ConversationLine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversationLine(
      fields[0] as String,
      character: fields[2] as Character?,
      characterName: fields[3] as String?,
      characterPic: fields[4] as CharacterPic?,
    )..isRichText = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, ConversationLine obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.isRichText)
      ..writeByte(2)
      ..write(obj.character)
      ..writeByte(3)
      ..write(obj.characterName)
      ..writeByte(4)
      ..write(obj.characterPic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationLineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
