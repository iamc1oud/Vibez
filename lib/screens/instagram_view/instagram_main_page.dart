import 'package:flutter/material.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:vibez/_utils/constants.dart';
import 'package:vibez/_utils/screen_size.dart';
import 'package:vibez/caching/hive_cache.dart';
import 'package:vibez/screens/instagram_view/instagram_download_link_field_page.dart';
import 'package:vibez/screens/instagram_view/instagram_download_section.dart';
import 'package:vibez/widgets/styled_load_spinner.dart';

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
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Typicons.trash,
                  size: 16,
                ),
                onPressed: () {},
              )
            ],
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kRadius),
              child: Container(
                decoration: BoxDecoration(color: Colors.black),
                height: AppSize(context).height * 0.3,
                width: AppSize(context).width * 0.9,
                child: Image.network(
                  data["thumbnail_src"],
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

  @override
  Widget build(BuildContext context) {
    reelsNotifier = context.watch<ReelsHiveNotifier>();

    return Scaffold(
      body: reelsNotifier?.box == null
          ? Center(child: StyledLoadSpinner())
          : CustomScrollView(
              slivers: [
                InstagramLinkPage(),
                DownloadSection(length: reelsNotifier?.length ?? 0),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildMetadataCard(
                      reelsNotifier?.box?.values.elementAt(index));
                }, childCount: reelsNotifier?.box?.keys.length ?? 0))
              ],
            ),
    );
  }
}
