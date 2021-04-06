import 'dart:isolate';
import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibez/_utils/utils.dart';
import 'package:vibez/repository/instagram_repository.dart';
import 'package:vibez/widgets/text_form_field.dart';

class InstagramLinkPage extends StatefulWidget {
  @override
  _InstagramLinkPageState createState() => _InstagramLinkPageState();
}

class _InstagramLinkPageState extends State<InstagramLinkPage> {
  TextEditingController _linkCtrl = TextEditingController();

  /// Form state
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Repository
  InstagramRepository repository = InstagramRepository();

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
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
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: AppSize(context).height * 0.4,
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
                    colors: [
                      Color(0xFFF58529),
                      Color(0xFFDD2476),
                    ])),
          ),
          Positioned(
            top: AppSize(context).height * 0.1,
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
            top: AppSize(context).height * 0.1,
            right: kPadding,
            child: Container(
                child: IconButton(
              color: Colors.white,
              onPressed: () {
                showBarModalBottomSheet(
                    bounce: true,
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: AppSize(context).height * 0.4,
                      );
                    });
              },
              icon: Icon(FontAwesome.sliders),
            )),
          ),
          Positioned(
            top: AppSize(context).height * 0.2,
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
            top: AppSize(context).height * 0.258,
            right: kPadding,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(kRadius)),
                width: AppSize(context).width * 0.12,
                child: IconButton(
                  icon: Icon(
                    FontAwesome.down_circled,
                    color: Colors.pink,
                  ),
                  onPressed: () async {
                    await validateLinkAndDownload();
                  },
                )),
          ),
        ],
      ),
    );
  }

  validateLinkAndDownload() async {
    try {
      var response = await repository.getTypeOfMedia(_linkCtrl.text);

      if (response == POSTTYPE.REEL) {
        var reelLink = await repository.downloadReels(_linkCtrl.text);

        final status = await Permission.storage.request();
        if (status.isGranted) {
          //final tempDir = await getExternalStorageDirectory();
          // var uuid = Uuid();
          // final taskId = await FlutterDownloader.enqueue(
          //     url: reelLink,
          //     savedDir: tempDir!.path,
          //     fileName: uuid.v1(),
          //     showNotification: true,
          //     openFileFromNotification: true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Storage permission denied")));
        }
      } else {}
    } catch (err) {
      throw err;
    }
  }
}
