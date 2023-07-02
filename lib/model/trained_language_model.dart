
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'trained_language_model.g.dart';

@HiveType(typeId: 1)
class TrainedLanguage {
  @HiveField(0)
  late Uuid id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late int progress;
  @HiveField(3)
  String? languageCode;
  @HiveField(4)
  String? trainedLanguage;
  @HiveField(5)
  DateTime? timestamp;
  @HiveField(6)
  bool isDownloaded = false;
  @HiveField(7)
  bool isInitialised = false;
}