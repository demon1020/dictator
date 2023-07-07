import 'package:dictator/core.dart';

class TextProvider with ChangeNotifier {
  late FlutterTts flutterTts;
  bool isReading = false;
  bool isEditEnabled = false;
  double pitch = 0.5;
  int showPitch = 50;
  double speechRate = 0.5;
  dynamic selectedLocale = "en-US";
  List<dynamic> supportedLocales = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  updatePitch(newValue){
    pitch = newValue;
    showPitch = (pitch * 100).round();
    print("Update Pitch : ${pitch.toStringAsFixed(2)} [$showPitch %]");
    notifyListeners();
  }
  Future<void> initializeTts() async {
    flutterTts = FlutterTts();

    await flutterTts.setLanguage(selectedLocale);
    await flutterTts.setPitch(pitch);
    flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
    notifyListeners();
  }

  void changeLanguage() async{
    await flutterTts.setLanguage(selectedLocale);
    notifyListeners();
  }

  Future<void> startReadingProcess() async {
    isReading = true;
    notifyListeners();
    await flutterTts.speak(dataController.text);
    notifyListeners();
  }

  Future<void> pauseReadingProcess() async {
    await flutterTts.pause();
    isReading = false;
    notifyListeners();
  }

  Future<void> stopReadingProcess() async {
    await flutterTts.stop();
    isReading = false;
    notifyListeners();
  }

  void switchEditingModes(){
    isEditEnabled = !isEditEnabled;
    notifyListeners();
  }
}
