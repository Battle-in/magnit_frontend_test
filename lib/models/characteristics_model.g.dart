// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characteristics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacteristicsAdapter extends TypeAdapter<Characteristics> {
  @override
  final int typeId = 1;

  @override
  Characteristics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Characteristics(
      fields[0] as int,
      fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Characteristics obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.weight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacteristicsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
