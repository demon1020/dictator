import 'dart:io';

import 'package:dictator/core.dart';

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

  init() async {
    if (trainedLanguages.isEmpty) {
      print("empty");
      languageTrainedDataMap.entries.toList().forEach((element) {
        TrainedLanguage language = TrainedLanguage();
        language.id = Uuid().v4();
        language.name = element.key;
        language.trainedLanguage = element.value;
        trainedLanguages.add(language);
      });
      await TrainedLanguageRepository().addAllToRepository(trainedLanguages);
      fetchTrainedLanguages();
    }
  }

  fetchTrainedLanguages() async{
    trainedLanguages = await TrainedLanguageRepository().fetchDataFromRepository();
  }

  updateRepository(TrainedLanguage language) async{
    await TrainedLanguageRepository().updateRepository(language);
  }

  deleteLanguageData(TrainedLanguage trainedLanguage) async{
    if(File(trainedLanguage.path!).existsSync()){
      File(trainedLanguage.path!).deleteSync();
      trainedLanguage.path = null;
      trainedLanguage.isDownloaded = false;
      trainedLanguage.isDownloading = false;
      await TrainedLanguageRepository().updateRepository(trainedLanguage);
    }
    notifyListeners();
  }

  downloadLanguage(TrainedLanguage item) async {
    item.isDownloading = true;
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
        item.isDownloaded = true;
        item.isDownloading = false;
        item.path = file.path;
        await updateRepository(item);
        notifyListeners();
      }
    }
  }
}
