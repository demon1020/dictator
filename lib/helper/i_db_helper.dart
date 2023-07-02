library interfaces;

import 'dart:async';

import 'package:hive/hive.dart';

abstract class IDBHelper {
  Future<List<T>> fetchData<T>(String boxName) async {
    final box = await Hive.openBox<T>(boxName);
    final list = box.values.toList();
    return list.cast<T>();
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
