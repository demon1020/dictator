import 'dart:developer';
import 'dart:io';

import 'package:dictator/core.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool scanning = false;
  bool isInitialised = false;
  String extractText = '';
  File? pickedImage;
  List<Document> documentList = [];

  void updateInitialisationValue(){
    isInitialised = true;
  }

  fetchDocuments() async {
    documentList = await DocumentRepository().fetchHiveData();
    notifyListeners();
  }

  void addToRepository(Document document) async {
    await DocumentRepository().addToRepository(document);
    await fetchDocuments();
  }

  void updateRepository(Document document) async {
    await DocumentRepository().updateRepository(document);
    await fetchDocuments();
  }

  void updateScanningStatus() {
    scanning = !scanning;
    notifyListeners();
  }

  void deleteFromRepository(Document document) async {
    await DocumentRepository().deleteFromRepository(document);
    await fetchDocuments();
  }

  Future pickImage({bool fromCamera = false}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery);

      if (pickedImage == null) return;

      final imageTemp = File(pickedImage.path);

      this.pickedImage = imageTemp;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    notifyListeners();
  }

  extractTextData() async {
    try{
      extractText = await FlutterTesseractOcr.extractText(pickedImage!.path, args: {"preserve_interword_spaces": "1"});
    }catch(e){
      log(e.toString());
    }
    notifyListeners();
  }

  processData({bool fromCamera = false}) async {
    extractText = '';
    scanning = true;
    await pickImage(fromCamera: fromCamera);
    await extractTextData();
    scanning = false;
    notifyListeners();
  }
}
