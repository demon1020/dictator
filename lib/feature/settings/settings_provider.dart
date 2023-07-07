import 'dart:io';

import 'package:dictator/core.dart';

class SettingsProvider extends ChangeNotifier {
  bool isExpanded = false;
  List<TrainedLanguage> trainedLanguages = [];
  String baseUrl = "https://github.com/tesseract-ocr/tessdata/raw/main/";

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
      await fetchTrainedLanguages();
      // await checkLanguagesInstalled();
    }
  }

  checkLanguagesInstalled() async {
    for (var element in trainedLanguages){
      bool isInstalled = await checkIfLanguageInstalled(element);

      if (!isInstalled &&
          (element.trainedLanguage == Constants.defaultLanguageEnglish ||
              element.trainedLanguage == Constants.defaultLanguageHindi)) {
        await downloadLanguage(element);
      }
      if (isInstalled) {
        await updateRepository(element);
      }
    }
  }

  fetchTrainedLanguages() async {
    trainedLanguages =
        await TrainedLanguageRepository().fetchDataFromRepository();
    if (trainedLanguages != null || trainedLanguages.isNotEmpty) {
      sortTrainedLanguages(trainedLanguages, Constants.firstLanguage);
    }
  }

  List<TrainedLanguage> sortTrainedLanguages(
      List<TrainedLanguage> trainedLanguages, String firstLanguage) {
    trainedLanguages.sort((a, b) {
      bool isDownloadedA = a.isDownloaded;
      bool isDownloadedB = b.isDownloaded;

      if (a.name.toLowerCase() == firstLanguage.toLowerCase()) {
        return -1;
      } else if (b.name.toLowerCase() == firstLanguage.toLowerCase()) {
        return 1;
      } else if (isDownloadedA == isDownloadedB) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else if (isDownloadedA) {
        return -1;
      } else {
        return 1;
      }
    });

    return trainedLanguages;
  }

  updateRepository(TrainedLanguage language) async {
    await TrainedLanguageRepository().updateRepository(language);
  }

  deleteLanguageData(TrainedLanguage trainedLanguage) async {
    if (File(trainedLanguage.path!).existsSync()) {
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
    bool isInstalled = false;
    isInstalled = await checkIfLanguageInstalled(item);
    if (!isInstalled) {
      Uint8List bytes =
          await ApiService().downloadFile("$baseUrl${item.trainedLanguage}");
      File file = await saveLanguage(item, bytes);
      item.isDownloaded = true;
      item.isDownloading = false;
      item.path = file.path;
    }
    await updateRepository(item);
    notifyListeners();
  }

  Future<File> saveLanguage(TrainedLanguage item, Uint8List bytes) async {
    String dir = await FlutterTesseractOcr.getTessdataPath();
    print('$dir/${item.trainedLanguage}');
    File file = File('$dir/${item.trainedLanguage}');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<bool> checkIfLanguageInstalled(TrainedLanguage item) async {
    bool isInstalled = false;
    Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());

    if (!dir.existsSync()) {
      dir.create();
    }

    dir.listSync().forEach((element) {
      String name = element.path.split('/').last;
      isInstalled |= name == item.trainedLanguage;
      if (isInstalled) {
        item.path = element.path;
        item.isDownloaded = true;
        item.isDownloading = false;
      }
    });

    print("Language is installed : $isInstalled");
    return isInstalled;
  }
}
