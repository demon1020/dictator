import 'package:dictator/model/document_model.dart';
import 'package:realm/realm.dart';

class RealmConfig {
  static late Realm documentRealm;
  static late App app;

  static createRealm() async {
    // Create a Configuration object
    var config = Configuration.local([Document.schema]);
    documentRealm = Realm(config);
  }
}
