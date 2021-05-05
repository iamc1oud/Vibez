import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:vibez/_utils/constants.dart';
import 'package:vibez/_utils/safe_print.dart';
import 'package:vibez/_utils/screen_size.dart';
import 'package:vibez/caching/hive_cache.dart';
import 'package:vibez/providers/instagram_provider.dart';
import 'package:vibez/screens/instagram_view/instagram_download_link_field_page.dart';
import 'package:vibez/screens/instagram_view/instagram_download_section.dart';
import 'package:vibez/widgets/styled_load_spinner.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      reelsNotifier?.openBox("reels");
      reelsNotifier?.getSizeOfData();
    });
    super.initState();
  }

  ReelsHiveNotifier? reelsNotifier;

  Widget _buildMetadataCard(dynamic data) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding * 0.1),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  data["profilePicture"],
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Text("@${data["username"]}",
                  style: Theme.of(context).textTheme.bodyText1!),
              Spacer(
                flex: 7,
              ),
              IconButton(
                icon: Icon(
                  Iconic.share,
                  color: Colors.green,
                  size: 16,
                ),
                onPressed: () async {
                  await Share.shareFiles([data["file_location"]]);
                },
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.trash,
                  size: 16,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  final File file = File(data["file_location"]);
                  await file.delete();
                  final File thumbnailFile = File(data["thumbnail"]);
                  await thumbnailFile.delete();
                  reelsNotifier!.box!.delete(
                      data["file_location"].split("files/")[1].split(".")[0]);
                  reelsNotifier!.getSizeOfData();
                  showToast(
                    'Deleted',
                    context: context,
                    animation: StyledToastAnimation.scale,
                    reverseAnimation: StyledToastAnimation.fade,
                    position: StyledToastPosition.top,
                    backgroundColor: Colors.red,
                    animDuration: Duration(seconds: 1),
                    duration: Duration(seconds: 2),
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.linear,
                  );
                },
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              _handleOpenFile(data["file_location"]);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kRadius / 2),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent)),
                height: AppSize(context).height * 0.2,
                width: AppSize(context).width * 0.95,
                child: Image.file(
                  File(data["thumbnail"]),
                  fit: BoxFit.cover,
                  cacheWidth: 250,
                ),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                showBarModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kRadius),
                        topRight: Radius.circular(kRadius),
                      ),
                    ),
                    context: context,
                    barrierColor: Colors.black54,
                    builder: (context) {
                      return Material(
                          child: SizedBox(
                        height: AppSize(context).height * 0.45,
                        child: Padding(
                          padding: EdgeInsets.all(kPadding),
                          child: ListView(children: [
                            SelectableText(data["caption"] ?? "")
                          ]),
                        ),
                      ));
                    });
              },
              child: Text("See caption"))
        ],
      ),
    );
  }

  double yTransValue = 0;

  @override
  Widget build(BuildContext context) {
    reelsNotifier = context.watch<ReelsHiveNotifier>();
    var instagramNotifier = context.watch<InstagramProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: reelsNotifier?.box == null
          ? Center(child: StyledLoadSpinner())
          : Stack(
              children: [
                NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification) {
                    if (notification.scrollDelta!.sign == 1) {
                      setState(() {
                        yTransValue = 100;
                      });
                    } else if (notification.scrollDelta!.sign == -1) {
                      setState(() {
                        yTransValue = 0;
                      });
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    slivers: [
                      InstagramLinkPage(),
                      DownloadSection(length: reelsNotifier?.length ?? 0),

                      /// Reverse the order of downloaded videos
                      SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return _buildMetadataCard(reelsNotifier?.box?.getAt(
                            reelsNotifier!.box!.keys.length - 1 - index));
                      }, childCount: reelsNotifier?.box?.keys.length ?? 0))
                    ],
                  ),
                ),
                instagramNotifier.isDownloadingReel
                    ? Container(
                        color: Colors.black54, child: StyledLoadSpinner())
                    : SizedBox()
              ],
            ),
    );
  }

  void _handleOpenFile(String path) async {
    OpenResult result = await OpenFile.open(
      path,
    );
    print(result.type);
  }
}
