import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vibez/caching/hive_cache.dart';
import 'package:vibez/providers/instagram_provider.dart';
import 'package:vibez/screens/instagram_view/instagram_main_page.dart';
import 'package:vibez/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.init((await getExternalStorageDirectory())!.path);

  SystemChrome.setEnabledSystemUIOverlays([]);

  await FlutterDownloader.initialize(debug: false);

  /// Call services
  InstagramProvider instagramNotifier = InstagramProvider();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ReelsHiveNotifier()),
      ChangeNotifierProvider.value(value: instagramNotifier)
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: ThemeMode.light,
        darkTheme: AppTheme.darkTheme,
        theme: AppTheme.lightTheme,
        home: Dashboard());
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainPage(),
    );
  }
}
