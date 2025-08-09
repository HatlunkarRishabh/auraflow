// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticky_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StickyNoteAdapter extends TypeAdapter<StickyNote> {
  @override
  final int typeId = 3;

  @override
  StickyNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StickyNote(
      content: fields[1] as String,
      colorHex: fields[2] as String,
      createdAt: fields[3] as DateTime?,
      id: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StickyNote obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.colorHex)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickyNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
