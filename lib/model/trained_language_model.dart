import 'package:dictator/core.dart';

part 'trained_language_model.g.dart';

@HiveType(typeId: 1)
class TrainedLanguage {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  String? languageCode;
  @HiveField(3)
  String? trainedLanguage;
  @HiveField(4)
  DateTime? timestamp;
  @HiveField(5)
  bool isDownloaded = false;
  @HiveField(6)
  bool isDownloading = false;
  @HiveField(7)
  String? path;
}