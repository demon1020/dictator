import 'package:dictator/core.dart';

class OutputScreen extends StatefulWidget {
  Document document;
  final List<dynamic> supportedLocales;
  final bool isEdit;

  OutputScreen({
    super.key,
    required this.supportedLocales,
    required this.document,
    this.isEdit = false,
  });

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<TextProvider>(context, listen: false);
    provider.nameController.text = widget.document.name;
    provider.supportedLocales = widget.supportedLocales;
    provider.dataController.text = widget.document.data!;
    provider.initializeTts();
  }

  @override
  void dispose() {
    // var provider = Provider.of<TextProvider>(context, listen: false);
    // provider.flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TextProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: TextFormField(
          minLines: 1,
          maxLines: provider.dataController.text.length,
          controller: provider.nameController,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.white,
            decoration: TextDecoration.none,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              widget.document.timestamp = DateTime.now();
              widget.document.isSaved = true;
              widget.document.name = provider.nameController.text;
              widget.document.data = provider.dataController.text;
              Navigator.pop(context, widget.document);
            },
            icon: Icon(
              Icons.save,
            ),
          ),
          // IconButton(
          //   onPressed: () async {
          //     await Clipboard.setData(ClipboardData(text: provider.data));
          //   },
          //   icon: Icon(
          //     Icons.copy,
          //   ),
          // ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState
                  ?.openEndDrawer(); // Open the drawer on button press
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Pitch [${provider.showPitch}]'),
                subtitle: AppSlider(
                  value: provider.pitch,
                  onChanged: (newValue) => provider.updatePitch(newValue),
                ),
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Handle item 2 tap
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.1,
            color: AppTheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 140,
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: AppTheme.secondary,
                    shape: StadiumBorder(
                      side: BorderSide.none,
                    ),
                  ),
                  child: DropdownButton<dynamic>(
                    isExpanded: true,
                    value: provider.selectedLocale,
                    onChanged: (newValue) {
                      setState(() {
                        provider.selectedLocale = newValue!;
                        provider.changeLanguage();
                      });
                    },
                    items: provider.supportedLocales.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(languageMap[option]!),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () async {
                      if (provider.isReading) {
                        await provider.pauseReadingProcess();
                      } else {
                        await provider.startReadingProcess();
                      }
                    },
                    icon: Icon(
                      provider.isReading ? Icons.pause : Icons.play_arrow,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () async {
                      await provider.stopReadingProcess();
                    },
                    icon: Icon(
                      Icons.stop,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: TextField(
              minLines: 1,
              maxLines: provider.dataController.text.length,
              // enabled: provider.isEditEnabled,
              controller: provider.dataController,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Handle item 1 tap
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Handle item 2 tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, String> languageMap = {
  'ko-KR': 'Korean',
  'ru-RU': 'Russian',
  'zh-TW': 'Chinese',
  'hu-HU': 'Hungarian',
  'th-TH': 'Thai',
  'nb-NO': 'Norwegian Bokmål',
  'da-DK': 'Danish',
  'tr-TR': 'Turkish',
  'et-EE': 'Estonian',
  'bs': 'Bosnian',
  'sw': 'Swahili',
  'pt-PT': 'Portuguese',
  'vi-VN': 'Vietnamese',
  'en-US': 'English',
  'sv-SE': 'Swedish',
  'su-ID': 'Sundanese',
  'bn-BD': 'Bengali',
  'el-GR': 'Greek',
  'hi-IN': 'Hindi',
  'fi-FI': 'Finnish',
  'km-KH': 'Khmer',
  'bn-IN': 'Bengali',
  'fr-FR': 'French',
  'uk-UA': 'Ukrainian',
  'en-AU': 'English',
  'nl-NL': 'Dutch',
  'fr-CA': 'French',
  'sr': 'Serbian',
  'pt-BR': 'Portuguese',
  'si-LK': 'Sinhala',
  'de-DE': 'German',
  'ku': 'Kurdish',
  'cs-CZ': 'Czech',
  'pl-PL': 'Polish',
  'sk-SK': 'Slovak',
  'fil-PH': 'Filipino',
  'it-IT': 'Italian',
  'ne-NP': 'Nepali',
  'hr': 'Croatian',
  'zh-CN': 'Chinese',
  'es-ES': 'Spanish',
  'cy': 'Welsh',
  'ja-JP': 'Japanese',
  'sq': 'Albanian',
  'yue-HK': 'Cantonese',
  'en-IN': 'English',
  'es-US': 'Spanish',
  'jv-ID': 'Javanese',
  'la': 'Latin',
  'id-ID': 'Indonesian',
  'ro-RO': 'Romanian',
  'ca': 'Catalan',
  'ta': 'Tamil',
  'en-GB': 'English',
};
