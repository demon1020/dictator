import 'package:dictator/core.dart';

class DocumentRepository extends IDBHelper{

  fetchDocumentsData() async {
    List<Document> data = await fetchData<Document>("document");
    return data;
  }

}