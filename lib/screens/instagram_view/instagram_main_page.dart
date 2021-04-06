import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibez/_utils/constants.dart';
import 'package:vibez/_utils/screen_size.dart';
import 'package:vibez/screens/instagram_view/instagram_download_link_field_page.dart';
import 'package:vibez/screens/instagram_view/instagram_download_section.dart';
import 'package:vibez/widgets/styled_load_spinner.dart';

class InstagramMainPage extends StatefulWidget {
  @override
  _InstagramMainPageState createState() => _InstagramMainPageState();
}

class _InstagramMainPageState extends State<InstagramMainPage> {
  int? length;
  Box? storageBox;
  @override
  void initState() {
    openBox();
    super.initState();
  }

  openBox() async {
    var box = await Hive.openBox("reels");
    setState(() {
      storageBox = box;
      length = storageBox?.toMap().keys.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storageBox == null
          ? StyledLoadSpinner()
          : CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    InstagramLinkPage(),
                    DownloadSection(),
                  ]),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildMetadataCard(
                      storageBox?.values.elementAt(index));
                }, childCount: storageBox?.keys.length ?? 0))
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var directory = (await getExternalStorageDirectory())!.path;
          var files = Directory(directory).listSync();
        },
        child: Text("Get files"),
      ),
    );
  }

  Widget _buildMetadataCard(dynamic data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(data["profilePicture"]),
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
                  size: 14,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Typicons.trash,
                  size: 14,
                ),
                onPressed: () {},
              )
            ],
          ),
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(kRadius)),
            height: AppSize(context).height * 0.4,
            width: AppSize(context).width * 0.9,
            child: Image.network(
              data["thumbnail_src"],
              cacheHeight: 512,
            ),
          )
        ],
      ),
    );
  }
}
