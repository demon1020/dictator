import 'package:dictator/core.dart';

abstract class IDBHelper {
  Future<List<T>> fetchData<T>(String boxName) async {
    final box = await Hive.openBox<T>(boxName);
    final list = box.values.toList();
    return list.cast<T>();
  }

  Future<void> addToBox<T>(String boxName,T data) async {
    Box box;
    if(!Hive.isBoxOpen(boxName)){
      box = await Hive.openBox<T>(boxName);
    }else{
      box = Hive.box<T>(boxName);
    }
    box.add(data);
  }

  Future<void> addAllToBox<T>(String boxName,List<T> data) async {
    Box box;
    if(!Hive.isBoxOpen(boxName)){
      box = await Hive.openBox<T>(boxName);
    }else{
      box = Hive.box<T>(boxName);
    }
    box.addAll(data);
  }
  Future<void> updateBox<T>(String boxName,T data, int index) async {
    Box box;
    if(!Hive.isBoxOpen(boxName)){
      box = await Hive.openBox<T>(boxName);
    }else{
      box = Hive.box<T>(boxName);
    }
    box.putAt(index, data);
  }

  Future<void> deleteFromBox<T>(String boxName, int index) async {
    Box box;
    if(!Hive.isBoxOpen(boxName)){
      box = await Hive.openBox<T>(boxName);
    }else{
      box = Hive.box<T>(boxName);
    }
    box.deleteAt(index);
  }

  Future<void> deleteBox<T>(String boxName) async {
    Box box;
    if(!Hive.isBoxOpen(boxName)){
      box = await Hive.openBox<T>(boxName);
    }else{
      box = Hive.box<T>(boxName);
    }
    box.deleteFromDisk();
  }

  saveData<T>(List<T> dataArray, String boxName,{bool deleteBoxDataIfEmpty = false}) async {
    if (dataArray != null && dataArray.isNotEmpty) {
      Box box = await Hive.openBox<T>(boxName);
      box.deleteAll(box.keys);
      for (T obj in dataArray) {
        box.add(obj);
      }
    }else{
      if(deleteBoxDataIfEmpty){
        Box box = await Hive.openBox<T>(boxName);
        box.deleteAll(box.keys);
      }
    }
  }
}
