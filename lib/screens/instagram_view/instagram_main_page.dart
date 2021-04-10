import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:vibez/_utils/constants.dart';
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
                flex: 6,
              ),
              IconButton(
                icon: Icon(
                  Iconic.share,
                  size: 16,
                ),
                onPressed: () async {
                  await Share.shareFiles([data["file_location"]]);
                },
              ),
              IconButton(
                icon: Icon(
                  Typicons.trash,
                  size: 16,
                ),
                onPressed: () async {
                  final File file = File(data["file_location"]);
                  await file.delete();
                  reelsNotifier!.box!.delete(
                      data["file_location"].split("files/")[1].split(".")[0]);
                  reelsNotifier!.getSizeOfData();
                },
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              _handleOpenFile(data["file_location"]);
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kRadius),
                child: Container(
                  decoration: BoxDecoration(color: Colors.black),
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
                    return true;
                  },
                  child: CustomScrollView(
                    slivers: [
                      InstagramLinkPage(),
                      DownloadSection(length: reelsNotifier?.length ?? 0),
                      SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return _buildMetadataCard(
                            reelsNotifier?.box?.values.elementAt(index));
                      }, childCount: reelsNotifier?.box?.keys.length ?? 0))
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedContainer(
                      color: Colors.transparent,
                      transform: Matrix4.translationValues(0, yTransValue, 0),
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        width: AppSize(context).width * 0.6,
                        height: 60,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.pink]),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/ic_instagram.png",
                              height: 40,
                            ),
                            Image.asset(
                              "assets/ic_pinterest.png",
                              height: 40,
                            ),
                            Image.asset(
                              "assets/ic_youtube.png",
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
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
    print(path);
    OpenResult result = await OpenFile.open(
      path,
    );
    print(result.type);
  }
}
