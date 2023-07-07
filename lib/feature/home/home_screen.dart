import 'dart:io';

import 'package:dictator/core.dart';
import 'package:intl/intl.dart';

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
    var provider = Provider.of<HomeScreenProvider>(context, listen: false);

    init();

    super.initState();
  }

  // initialiseTrainedLanguages() async{
  //   final provider = Provider.of<SettingsProvider>(context, listen: false);
  //   await provider.fetchTrainedLanguages();
  //   await provider.init();
  // }

  init() async {
    supportedLocales = [];
    List<dynamic> tempLocales = [];

    var provider = Provider.of<HomeScreenProvider>(context, listen: false);
    provider.fetchDocuments();

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
        title: GestureDetector(onTap: () {}, child: Text('DICTATOR')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Get.to(() => SettingsScreen());
            },
          ),
        ],
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
                itemCount: provider.documentList.length,
                separatorBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider());
                },
                itemBuilder: (context, index) {
                  var item = provider.documentList[index];
                  return ListTile(
                    onTap: () async {
                      Document document = await Get.to(
                        () => OutputScreen(
                          supportedLocales: supportedLocales,
                          document: item,
                          isEdit: true,
                        ),
                      );
                      if (document != null && document.isSaved == true) {
                        provider.updateRepository(document);
                      }
                    },
                    leading: item.path == null
                        ? Icon(Icons.image)
                        : !File(item.path!).existsSync()
                            ? Icon(Icons.image)
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ImageView(imagePath: item.path!),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: item.path.toString(),
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
                    subtitle: Text(
                      "${DateFormat.MMMMEEEEd().format(item.timestamp!)} ${DateFormat.jm().format(item.timestamp!)}",
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        provider.deleteFromRepository(item);
                      },
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                      ),
                    ),
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
                      // await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => OutputScreen(
                      //       supportedLocales: supportedLocales,
                      //       document: null,
                      //     ),
                      //   ),
                      // );
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
                      try {
                        Document document = await Get.to(
                          () => OutputScreen(
                            supportedLocales: supportedLocales,
                            document: Document(
                              id: Uuid().v4(),
                              name: "filename",
                              data: provider.extractText,
                            ),
                          ),
                        );
                        if (document != null && document.isSaved == true) {
                          String path =
                              await FileManager.createDirectory("images");
                          String fileName =
                              await FileManager.generateRandomFileName();
                          String fullPath =
                              path + Platform.pathSeparator + fileName;
                          FileManager.moveFile(provider.pickedImage!, fullPath);

                          document.path = fullPath;
                          provider.addToRepository(document);
                        }
                      } catch (e) {}

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
