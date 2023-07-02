import 'core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
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
      providers: Providers.getAllProviders(),
      child: GetMaterialApp(
        title: 'Dictator',
        theme: AppTheme.lightTheme,
        home: HomeScreen(),
      ),
    );
  }
}
