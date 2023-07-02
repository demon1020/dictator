import 'package:dictator/core.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    provider.fetchTrainedLanguages();
    provider.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              provider.toggleExpansionTile();
            },
            title: Text('Languages'),
            trailing: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                provider.isExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: AppTheme.black,
                size: 25,
              ),
            ),
          ),
          Visibility(
            visible: provider.isExpanded,
            child: SizedBox(
              height: size.height,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: provider.trainedLanguages.length,
                itemBuilder: (context, index) {
                  var item = provider.trainedLanguages[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: item.isDownloading
                        ? LinearProgressIndicator()
                        : (!item.isDownloading && item.isDownloaded)
                            ? Text('Downloaded',style: TextStyle(color: Colors.green),)
                            : SizedBox.shrink(),
                    trailing: IconButton(
                      onPressed: () {
                        if(!item.isDownloaded){
                          provider.downloadLanguage(item);
                        }else{
                          provider.deleteLanguageData(item);
                        }
                        setState(() {});
                      },
                      icon: Icon(item.isDownloaded
                          ? Icons.delete_forever
                          : Icons.cloud_download),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
