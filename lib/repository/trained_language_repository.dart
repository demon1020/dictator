
import 'package:dictator/helper/i_db_helper.dart';
import 'package:dictator/model/trained_language_model.dart';

class TrainedLanguageRepository extends IDBHelper{

  Future<List<TrainedLanguage>> fetchTrainedLanguages() async{
    List<TrainedLanguage> data = await fetchData<TrainedLanguage>("trainedLanguage");
    return data;
  }


}