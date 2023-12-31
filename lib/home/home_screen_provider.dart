import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreenProvider extends ChangeNotifier{
  bool scanning = false;
  String extractText = '';
  File? pickedImage;

  void updateScanningStatus(){
    scanning = !scanning;
    notifyListeners();
  }

  Future pickImage({bool fromCamera = false}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);

      if(pickedImage == null) return;

      final imageTemp = File(pickedImage.path);

      this.pickedImage = imageTemp;
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
    notifyListeners();
  }

  extractTextData() async{
    extractText = await FlutterTesseractOcr.extractText(pickedImage!.path);
    notifyListeners();
  }

  processData({bool fromCamera = false}) async{
    extractText = '';
    scanning = true;
    await pickImage(fromCamera: fromCamera);
    await extractTextData();
    scanning = false;
    notifyListeners();
  }
}