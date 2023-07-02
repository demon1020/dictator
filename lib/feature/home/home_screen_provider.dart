import 'dart:io';

import 'package:dictator/core.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool scanning = false;
  String extractText = '';
  File? pickedImage;
  List<Document> documentList = [];

  fetchDocuments() async{
    documentList = await DocumentRepository().fetchDocumentsData();
  }

  void updateScanningStatus() {
    scanning = !scanning;
    notifyListeners();
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
    extractText = await FlutterTesseractOcr.extractText(pickedImage!.path);
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

