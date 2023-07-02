// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trained_language_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrainedLanguageAdapter extends TypeAdapter<TrainedLanguage> {
  @override
  final int typeId = 1;

  @override
  TrainedLanguage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrainedLanguage()
      ..id = fields[0] as Uuid
      ..name = fields[1] as String
      ..progress = fields[2] as int
      ..languageCode = fields[3] as String?
      ..trainedLanguage = fields[4] as String?
      ..timestamp = fields[5] as DateTime?
      ..isDownloaded = fields[6] as bool
      ..isInitialised = fields[7] as bool;
  }

  @override
  void write(BinaryWriter writer, TrainedLanguage obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.progress)
      ..writeByte(3)
      ..write(obj.languageCode)
      ..writeByte(4)
      ..write(obj.trainedLanguage)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.isDownloaded)
      ..writeByte(7)
      ..write(obj.isInitialised);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainedLanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
