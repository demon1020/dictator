import '../../core.dart';

class Providers {
  static List<SingleChildWidget> getAllProviders() {
    List<SingleChildWidget> _providers = [
      ChangeNotifierProvider(create: (context) => TextProvider()),
      ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
      ChangeNotifierProvider(create: (context) => SettingsProvider()),
    ];
    return _providers;
  }
}
