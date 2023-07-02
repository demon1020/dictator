import 'package:dictator/core.dart';

class TrainedLanguageRepository extends IDBHelper{
  String boxName = "trainedLanguage";

  Future<List<TrainedLanguage>> fetchDataFromRepository() async{
    List<TrainedLanguage> data = await fetchData<TrainedLanguage>(boxName);
    return data;
  }

  Future<void> addToRepository(TrainedLanguage trainedLanguage) async {
    await addToBox(boxName, trainedLanguage);
  }

  Future<void> updateRepository(TrainedLanguage trainedLanguage) async {
    List<TrainedLanguage> data = await fetchDataFromRepository();
    int index = data.indexWhere((element) => element.id == trainedLanguage.id);
    if(index != -1){
      await updateBox(boxName, trainedLanguage, index);
    }else{
      print("Cannot update, index does not exits");
    }
  }

  Future<void> deleteFromRepository(TrainedLanguage trainedLanguage) async {
    List<TrainedLanguage> data = await fetchDataFromRepository();
    int index = data.indexWhere((element) => element.id == trainedLanguage.id);
    if(index != -1){
      await deleteFromBox(boxName, index);
    }else{
      print("Cannot delete, index does not exits");
    }
  }

  Future<void> addAllToRepository(List<TrainedLanguage> trainedLanguage) async {
    await addAllToBox(boxName, trainedLanguage);
  }

}