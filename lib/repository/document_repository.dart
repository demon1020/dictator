import 'package:dictator/helper/i_db_helper.dart';
import 'package:dictator/model/document_model.dart';

class DocumentRepository extends IDBHelper{

  fetchDocumentsData() async {
    List<Document> data = await fetchData<Document>("document");
    return data;
  }

}