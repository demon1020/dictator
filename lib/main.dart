import 'package:dictator/output/output_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_config/realm_config.dart';
import 'app_config/theme.dart';
import 'home/home_screen.dart';
import 'home/home_screen_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RealmConfig.createRealm();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TextProvider()),
        ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
      ],
      child: MaterialApp(
        title: 'Dictator',
        theme: AppTheme.lightTheme,
        home: HomeScreen(),
      ),
    );
  }
}
