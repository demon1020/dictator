import 'package:dictator/core.dart';

class RegisterHiveAdapters {
  static void registerHiveAdapters() {
    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(TrainedLanguageAdapter());
  }
}
