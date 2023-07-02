import 'dart:io';

import 'package:dictator/core.dart';

enum FileExtention {jpg, png}
class FileManager {
  static Future<String> findLocalPath() async {
    print('IsAndroid:${Platform.isAndroid}');
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.absolute.path;
  }

  static Future<int> deleteFile(String path) async {
    //file
    try {
      // File file = File(path);
      // await file.delete();

      final dir = Directory(path);
      print('dir' + dir.path);
      dir.deleteSync(recursive: true);
    } catch (e) {
      return 1;
    }
    return 0;
  }
  //
  // static Future<String> unarchiveZipFile(String path, String filename) async {
  //   //file manager class
  //   try{
  //     String zippedFile = path + Platform.pathSeparator + filename;
  //     final bytes = File(zippedFile).readAsBytesSync();
  //     var archive = ZipDecoder().decodeBytes(bytes);
  //     for (var file in archive) {
  //       var fileName = path + file.name;
  //       if (file.isFile) {
  //         var outFile = File(fileName);
  //         outFile = await outFile.create(recursive: true);
  //         await outFile.writeAsBytes(file.content);
  //       }
  //     }
  //   }catch(e){
  //     print(e);
  //     return AlertMessages.validationUnArchivingMessage;
  //   }
  //   return "";
  // }
  //
  // static Future<String> loadAsset(String name) async {
  //   return await rootBundle.loadString(name);
  //   //'assets/config.json'
  // }
  //
  // static copyFileFromRootToDirectory(String fromPath, String name) async {
  //   ByteData data = await rootBundle.load(fromPath);
  //   List<int> bytes =
  //   data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   String path = appDocDir.path + Platform.pathSeparator + name;
  //   print(path);
  //   await File(path).writeAsBytes(bytes);
  // }
  //
  // static Future<String> pathForDocument(String name) async {
  //   String localPath = await findLocalPath();
  //   print(localPath + Platform.pathSeparator + name);
  //   return localPath + Platform.pathSeparator + name;
  // }
  //
  // static Future<Uint8List> compressFile(File file) async {
  //   var result = await FlutterImageCompress.compressWithFile(
  //     file.absolute.path,
  //     minWidth: 2300,
  //     minHeight: 1500,
  //     quality: 50,
  //     // rotate: 90,
  //   );
  //   print(file.lengthSync());
  //   print(result.length);
  //   return result;
  // }
  //
  // static Future<bool> checkIfFileExists(String filePath) async {
  //   String path = await FileManager.findLocalPath();
  //   path = '$path/$filePath';
  //   bool pathExists = await File(path).exists();
  //   return pathExists;
  // }

  static Future<bool> checkIfImageExists(String filePath) async {
    // String path = await FileManager.findLocalPath();
    // path = '$path/$filePath';
    bool pathExists = await File(filePath).exists();
    return pathExists;
  }

  static Future<File> moveFile(File sourceFile, String destination) async {
    try {
      //Create directory if not exists
      File(destination).createSync(recursive: true);
      return await sourceFile.rename(destination);
    } on FileSystemException {
      // if rename fails, copy the source file and then delete it
      final File newFile = await sourceFile.copy(destination);
      await sourceFile.delete();
      return newFile;
    }
  }

  static createDirectory(String directoryName) async{
    final path = await FileManager.findLocalPath();
    String fullPath;
    if(directoryName.isEmpty || directoryName == ""){
      fullPath = path;
    }else{
      fullPath = path + Platform.pathSeparator + directoryName;
    }
    Directory appDocumentsDirectory = Directory(fullPath);
    final isExist = appDocumentsDirectory.existsSync();
    if (!isExist) {
      await appDocumentsDirectory.create(recursive: true);
    }
    return appDocumentsDirectory.path;
  }

  static generateRandomFileName({FileExtention extention = FileExtention.jpg}) async{
    String fileName = "${Uuid().v4()}.${extention.name}";
    return fileName;
  }
}
