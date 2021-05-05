import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibez/_utils/utils.dart';
import 'package:vibez/caching/hive_cache.dart';
import 'package:vibez/providers/instagram_provider.dart';
import 'package:vibez/widgets/text_form_field.dart';

class InstagramLinkPage extends StatefulWidget {
  @override
  _InstagramLinkPageState createState() => _InstagramLinkPageState();
}

class _InstagramLinkPageState extends State<InstagramLinkPage> {
  TextEditingController _linkCtrl = TextEditingController();

  /// Form state
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ReceivePort _port = ReceivePort();

  InstagramProvider? instagramNotifier;

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      print(data);
      String id = data[0];
      DownloadTaskStatus status = data[1];
      print(status.value);
      int progressValue = data[2];
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    Future.delayed(Duration(milliseconds: 200), () {
      send.send([id, status, progress]);
    });
  }

  @override
  Widget build(BuildContext context) {
    instagramNotifier = context.watch<InstagramProvider>();
    return SliverAppBar(
      expandedHeight: AppSize(context).height * 0.3,
      pinned: true,
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      forceElevated: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: 220,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: Image.asset(
                  "assets/giphy.gif",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 60,
                left: kPadding,
                child: Container(
                  child: Text(
                    "Vibez",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: kPadding,
                child: Container(
                    height: 120,
                    width: AppSize(context).width * 0.75,
                    child: Form(
                      key: _formKey,
                      child: VTextFormField(
                        suffixIcon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onTapSuffixIcon: () {
                          _linkCtrl.clear();
                        },
                        inputType: TextInputType.url,
                        controller: _linkCtrl,
                        validator: (String val) {
                          if (val.isEmpty) {
                            return "Provide link";
                          }
                          return null;
                        },
                        prefixIcon: Icon(
                          FontAwesome.link,
                          color: Colors.pink,
                        ),
                        hintText: "Paste post link here",
                      ),
                    )),
              ),
              Positioned(
                top: 135,
                right: kPadding,
                child: Container(
                    width: AppSize(context).width * 0.12,
                    child: IconButton(
                        icon: Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          validateLinkAndDownload();
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }

  validateLinkAndDownload() async {
    if (_formKey.currentState!.validate()) {
      await instagramNotifier?.downloadReel(_linkCtrl.text);
      var response = instagramNotifier?.data;

      if (response!["error"]) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response["message"])));
        return;
      }

      final status = await Permission.storage.request();

      if (status.isGranted) {
        await FlutterDownloader.loadTasks();

        final tempDir = await getExternalStorageDirectory();

        var uuid = Uuid();
        var fileName = uuid.v1();
        var imgSrcPath = tempDir!.path + "/images";
        var imgNamePath = tempDir.path + '/images/$fileName.jpg';
        var image = await get(Uri.parse(response["thumbnail_src"]));
        await Directory(imgSrcPath).create(recursive: true);
        File file = File(imgNamePath);
        file.writeAsBytes(image.bodyBytes);

        response.putIfAbsent("thumbnail", () => imgNamePath);
        response.putIfAbsent(
            "file_location", () => tempDir.path + "\/$fileName" + ".mp4");
        await FlutterDownloader.enqueue(
                url: response["link"],
                savedDir: tempDir.path,
                fileName: fileName + ".mp4",
                showNotification: true,
                openFileFromNotification: true)
            .then((value) async {
          var reelsBox = await Hive.openBox("reels");
          reelsBox.put(fileName, response);

          Provider.of<ReelsHiveNotifier>(context, listen: false)
              .getSizeOfData();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Storage permission denied")));
      }
    }
  }
}
