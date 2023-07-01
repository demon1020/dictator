import 'package:realm/realm.dart';

part 'document_model.g.dart';

@RealmModel()
class _Document {
  late Uuid id;
  late String name;
  String? path;
  String? data;
  String? status;
  DateTime? timestamp;
  bool isSelected = false;
  bool isSaved = false;
}