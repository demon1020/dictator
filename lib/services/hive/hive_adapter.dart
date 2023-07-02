import 'package:dictator/model/document_model.dart';
import 'package:dictator/model/trained_language_model.dart';
import 'package:hive/hive.dart';

class RegisterHiveAdapters {
  static void registerHiveAdapters() {
    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(TrainedLanguageAdapter());
  }
}
