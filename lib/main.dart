import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibez/screens/instagram_view/instagram_main_page.dart';
import 'package:vibez/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize hive DB
  Hive.init((await getExternalStorageDirectory())!.path);

  /// Create a reels box
  await Hive.openBox("reels");

  await FlutterDownloader.initialize(debug: true);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: AppTheme.darkTheme,
        theme: AppTheme.lightTheme,
        home: Dashboard());
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InstagramMainPage(),
    );
  }
}
