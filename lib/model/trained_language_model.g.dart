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
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..languageCode = fields[2] as String?
      ..trainedLanguage = fields[3] as String?
      ..timestamp = fields[4] as DateTime?
      ..isDownloaded = fields[5] as bool
      ..isDownloading = fields[6] as bool
      ..path = fields[7] as String?;
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
      ..write(obj.languageCode)
      ..writeByte(3)
      ..write(obj.trainedLanguage)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.isDownloaded)
      ..writeByte(6)
      ..write(obj.isDownloading)
      ..writeByte(7)
      ..write(obj.path);
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
