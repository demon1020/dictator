import 'package:dictator/core.dart';

part 'document_model.g.dart';

@HiveType(typeId: 0)
class Document {
  @HiveField(0)
  late Uuid id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  String? path;
  @HiveField(3)
  String? data;
  @HiveField(4)
  String? status;
  @HiveField(5)
  DateTime? timestamp;
  @HiveField(6)
  bool isSelected = false;
  @HiveField(7)
  bool isSaved = false;
}