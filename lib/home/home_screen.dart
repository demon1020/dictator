import 'dart:io';

import 'package:dictator/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../app_config/theme.dart';
import '../model/document_model.dart';
import '../output/output_screen.dart';
import '../services/file_manager.dart';
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
    supportedLocales = [];
    List<dynamic> tempLocales = [];

    tempLocales = await flutterTts.getLanguages;
    for (var datum in tempLocales) {
      bool isInstalled = await flutterTts.isLanguageInstalled(datum);
      if (isInstalled) {
        supportedLocales.add(datum);
      }
    }
    print("All Locale : ${tempLocales.length}");
    print("Installed Locale : ${supportedLocales.length}");
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeScreenProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              provider.addDocument(
                  Document(DateTime.now().microsecondsSinceEpoch, "Babu"));
            },
            child: Text('Dictator')),
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
                itemCount: provider.fetchDocuments().length,
                separatorBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider());
                },
                itemBuilder: (context, index) {
                  var item = provider.fetchDocuments()[index];
                  return ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutputScreen(
                            extractText: item.data!,
                            supportedLocales: supportedLocales,
                          ),
                        ),
                      );
                    },
                    leading: item.path == null
                        ? Icon(Icons.image)
                        : !File(item.path!).existsSync()
                        ? Icon(Icons.image)
                        : GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageView(imagePath: item.path!),
                          ),
                        );
                      },
                      child: Hero(
                        tag: "imageHero",
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.file(
                            File(item.path!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      item.name,
                    ),
                    subtitle: Text(DateTime.now().toString()),
                    trailing: IconButton(
                        onPressed: () {
                          provider.deleteDocument(item);
                        },
                        icon: Icon(Icons.delete)),
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
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutputScreen(
                            extractText: provider.extractText,
                            supportedLocales: supportedLocales,
                          ),
                        ),
                      );
                      if (result != null) {
                        String path = await FileManager.createDirectory("images");
                        String fileName = await FileManager.generateRandomFileName();
                        String fullPath = path + Platform.pathSeparator + fileName;
                        FileManager.moveFile(provider.pickedImage!, fullPath);

                        provider.addDocument(
                          Document(
                            DateTime.now().microsecondsSinceEpoch,
                            result["name"],
                            data: result["data"],
                            path: fullPath,
                          ),
                        );
                      }
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