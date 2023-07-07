import 'package:dictator/core.dart';

class DocumentRepository extends IDBHelper{
  String boxName = "document";

  fetchHiveData() async {
    List<Document> data = await fetchData<Document>(boxName);
    return data;
  }

  Future<void> updateRepository(Document item) async {
    List<Document> data = await fetchHiveData();
    int index = data.indexWhere((element) => element.id == item.id);
    if(index != -1){
      await updateBox<Document>(boxName, item, index);
    }else{
      print("Cannot update, index does not exits");
    }
  }

  Future<void> deleteFromRepository(Document item) async {
    List<Document> data = await fetchHiveData();
    int index = data.indexWhere((element) => element.id == item.id);
    if(index != -1){
      await deleteFromBox<Document>(boxName, index);
    }else{
      print("Cannot delete, index does not exits");
    }
  }


  Future<void> addToRepository<T>(T item) async {
    await addToBox(boxName, item);
  }

  Future<void> addAllToRepository<T>(List<T> itemList) async {
    await addAllToBox(boxName, itemList);
  }
}