import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibez/screens/instagram_view/instagram_download_link_field_page.dart';
import 'package:vibez/screens/instagram_view/instagram_download_section.dart';

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
    setState(() async {
      storageBox = box;
      length = storageBox!.toMap().keys.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              InstagramLinkPage(),
              DownloadSection(),
            ]),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(storageBox!.values
                          .elementAt(index)["profilePicture"]),
                    )
                  ],
                )
              ],
            );
          }, childCount: storageBox!.keys.length))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var directory = (await getExternalStorageDirectory())!.path;
          var files = Directory(directory).listSync();
          print(files);
          print(storageBox!.toMap());
        },
        child: Text("Get files"),
      ),
    );
  }
}
