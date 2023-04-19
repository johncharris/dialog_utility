// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_pic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterPicAdapter extends TypeAdapter<CharacterPic> {
  @override
  final int typeId = 1;

  @override
  CharacterPic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterPic(
      fields[0] as String,
      fields[1] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterPic obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.bytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterPicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
