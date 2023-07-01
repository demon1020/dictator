import 'package:dictator/model/document_model.dart';
import 'package:realm/realm.dart';

import '../app_config/realm_config.dart';

class DocumentRepository{

  RealmResults<Document> fetchDocumentsData(){
    return RealmConfig.documentRealm.all<Document>();
  }

  void addDocument(Document document, {bool update = false}) {
    RealmConfig.documentRealm.write((){
      RealmConfig.documentRealm.add(document,update: update);
    });
  }

  void deleteDocument(Document document) {
    RealmConfig.documentRealm.write((){
      RealmConfig.documentRealm.delete<Document>(document);
    });
  }

  void deleteAllDocument() {
    RealmConfig.documentRealm.write((){
      RealmConfig.documentRealm.deleteAll<Document>();
    });
  }
}