import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  /// Loading bar for showing status that file is downloading
  bool _isDownloading = false;
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
      backgroundColor: Colors.transparent,
      pinned: true,
      floating: true,
      elevation: 0,
      forceElevated: true,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: AppSize(context).height * 0.3,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(kRadius),
                        bottomRight: Radius.circular(kRadius)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        // colors: MediaQuery.of(context).platformBrightness ==
                        //         Brightness.dark
                        //?
                        colors: [
                          Color(0xFFF58529),
                          Color(0xFFDD2476),
                        ]
                        //:
                        // colors: [
                        //   Color(0xFF413DB5),
                        //   Color(0xFF140F2D),]
                        )),
              ),
              Positioned(
                top: AppSize(context).height * 0.05,
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
              // Positioned(
              //   top: AppSize(context).height * 0.05,
              //   right: kPadding,
              //   child: Container(
              //       child: IconButton(
              //     color: Colors.white,
              //     onPressed: () {
              //       showBarModalBottomSheet(
              //           bounce: true,
              //           context: context,
              //           builder: (context) {
              //             return SizedBox(
              //               height: AppSize(context).height * 0.4,
              //               child: ListTile(
              //                 title: Text("Enable dark mode"),
              //                 trailing: Switch(
              //                   value: true,
              //                   onChanged: (val) {
              //                     print(val);
              //                   },
              //                 ),
              //               ),
              //             );
              //           });
              //     },
              //     icon: Icon(FontAwesome.sliders),
              //)),
              //),
              Positioned(
                top: AppSize(context).height * 0.12,
                left: kPadding,
                child: Container(
                    height: 120,
                    width: AppSize(context).width * 0.75,
                    child: Form(
                      key: _formKey,
                      child: VTextFormField(
                        inputType: TextInputType.url,
                        validator: (String val) {
                          if (val.isEmpty) {
                            return "Provide link";
                          }
                          return null;
                        },
                        controller: _linkCtrl,
                        prefixIcon: Icon(
                          FontAwesome.link,
                          color: Colors.pink,
                        ),
                        hintText: "Paste post link here",
                      ),
                    )),
              ),
              Positioned(
                top: AppSize(context).height * 0.175,
                right: kPadding,
                child: instagramNotifier!.isDownloadingReel || _isDownloading
                    ? CircularProgressIndicator()
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.pink[100],
                            borderRadius: BorderRadius.circular(kRadius)),
                        width: AppSize(context).width * 0.12,
                        child: IconButton(
                            icon: Icon(
                              FontAwesome.down_circled,
                              color: Colors.pink,
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

      final status = await Permission.storage.request();

      if (status.isGranted) {
        await FlutterDownloader.loadTasks();

        final tempDir = await getExternalStorageDirectory();
        var uuid = Uuid();
        var fileName = uuid.v1();
        await FlutterDownloader.enqueue(
                url: response?["link"],
                savedDir: tempDir!.path,
                fileName: fileName,
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
