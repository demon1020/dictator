import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../app_config/theme.dart';
import '../output/output_screen.dart';
import 'home_screen_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterTts flutterTts = FlutterTts();
  late List<dynamic> supportedLocales;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    supportedLocales = await flutterTts.getLanguages;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeScreenProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dictator'),
        centerTitle: true,
        // elevation: 0,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: ListView(
          children: [
            // Container(
            //   width: size.width,
            //   height: size.height * 0.1,
            //   color: AppTheme.primary,
            // ),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: AppTheme.scaffold,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: docs.length,
                separatorBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider());
                },
                itemBuilder: (context, index) {
                  var item = docs[index];
                  return ListTile(
                    leading: Icon(Icons.image),
                    title: Text(
                      item.name,
                    ),
                    subtitle: Text(DateTime.now().toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MaterialButton(
        onPressed: () => _showBottom(context),
        child: Container(
          width: 140,
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          decoration: ShapeDecoration(
            color: AppTheme.secondary,
            shape: StadiumBorder(
              side: BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.document_scanner_outlined,
              ),
              Text(
                'SCAN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottom(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        var provider = Provider.of<HomeScreenProvider>(context);

        return Visibility(
          visible: !provider.scanning,
          replacement: LoadingScreen(),
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Import an image to be converted',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await provider.processData(fromCamera: true);

                    if (provider.extractText.isNotEmpty) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutputScreen(
                            extractText: provider.extractText,
                            supportedLocales: supportedLocales,
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                      decoration: ShapeDecoration(
                        color: AppTheme.secondary,
                        shape: StadiumBorder(
                          side: BorderSide.none,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.camera,
                          color: AppTheme.black,
                        ),
                        title: Text(
                          'TAKE PICTURE',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateScanningStatus();
                    await provider.processData();

                    if (provider.extractText.isNotEmpty) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutputScreen(
                            extractText: provider.extractText,
                            supportedLocales: supportedLocales,
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      color: AppTheme.secondary,
                      shape: StadiumBorder(
                        side: BorderSide.none,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.photo,
                        color: AppTheme.black,
                      ),
                      title: Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

List<Document> docs = [
  Document(id: 1, name: "babu"),
  Document(id: 2, name: "babu"),
  Document(id: 3, name: "babu"),
  Document(id: 4, name: "babu"),
  Document(id: 5, name: "babu"),
  Document(id: 6, name: "babu"),
];

class Document {
  late int id;
  late String name;
  String? path;
  String? data;
  String? status;
  DateTime? timestamp;
  bool isSelected;

  Document(
      {required this.id,
      required this.name,
      this.path,
      this.data,
      this.status,
      this.timestamp,
      this.isSelected = false});
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Extracting Text data.....',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 50,
            ),
            LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
