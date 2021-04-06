import 'package:flutter/material.dart';
import 'package:vibez/screens/instagram_view/instagram_download_link_field_page.dart';
import 'package:vibez/screens/instagram_view/instagram_download_section.dart';

class InstagramMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          InstagramLinkPage(),
          DownloadSection(),
        ]))
      ],
    );
  }
}
