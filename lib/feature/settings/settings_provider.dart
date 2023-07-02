import 'dart:io';

import 'package:dictator/model/trained_language_model.dart';
import 'package:dictator/repository/data.dart';
import 'package:dictator/repository/trained_language_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:realm/realm.dart';

class SettingsProvider extends ChangeNotifier {
  bool isExpanded = false;
  List<TrainedLanguage> trainedLanguages = [];
  String baseUrl = "https://github.com/tesseract-ocr/tessdata/raw/main/";
  String path = "";
  bool bload = false;
  bool bDownloadtessFile = false;

  void toggleExpansionTile() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  init() {
    if (trainedLanguages.isEmpty) {
      print("empty");
      languageTrainedDataMap.entries.toList().forEach((element) {
        // TrainedLanguage language = TrainedLanguage(Uuid.v4(), element.key, 0,
        //     trainedLanguage: element.value, isInitialised: true);
        // addToRealmDb(language);
      });
      fetchTrainedLanguages();
    }
  }

  fetchTrainedLanguages() async{
    trainedLanguages = await TrainedLanguageRepository().fetchTrainedLanguages();
  }


  downloadLanguage(TrainedLanguage item) async {
    if (kIsWeb == false) {
      Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());
      if (!dir.existsSync()) {
        dir.create();
      }
      bool isInstalled = false;
      dir.listSync().forEach((element) {
        String name = element.path.split('/').last;
        isInstalled |= name == item.trainedLanguage;
      });
      print("Language is installed : $isInstalled");
      if (!isInstalled) {
        bDownloadtessFile = true;
        HttpClient httpClient = HttpClient();
        HttpClientRequest request = await httpClient
            .getUrl(Uri.parse("$baseUrl${item.trainedLanguage}"));
        HttpClientResponse response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        String dir = await FlutterTesseractOcr.getTessdataPath();
        print('$dir/${item.trainedLanguage}');
        File file = File('$dir/${item.trainedLanguage}');
        await file.writeAsBytes(bytes);
        bDownloadtessFile = false;
        print(isInstalled);
        // item.isDownloaded = true;
        // addToRealmDb(item, update: true);
      }
    }
  }
}
