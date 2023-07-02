import 'package:dictator/feature/home/home_screen_provider.dart';
import 'package:dictator/feature/settings/settings_provider.dart';
import 'package:dictator/services/hive/hive_adapter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'app_config/theme.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'feature/home/home_screen.dart';
import 'feature/output/output_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  print(appDocumentDirectory);
  await Permission.storage.request();
  Hive.init(appDocumentDirectory.path);
  RegisterHiveAdapters.registerHiveAdapters();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TextProvider()),
        ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: GetMaterialApp(
        title: 'Dictator',
        theme: AppTheme.lightTheme,
        home: HomeScreen(),
      ),
    );
  }
}
