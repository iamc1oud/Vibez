import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vibez/_utils/utils.dart';
import 'package:vibez/caching/hive_cache.dart';

// ignore: must_be_immutable
class DownloadSection extends StatefulWidget {
  final int? length;

  const DownloadSection({Key? key, this.length}) : super(key: key);
  @override
  _DownloadSectionState createState() => _DownloadSectionState();
}

class _DownloadSectionState extends State<DownloadSection> {
  double kDim = 60;
  int length = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      reelsHiveNotifier!.getSizeOfData();
    });
    super.initState();
  }

  ReelsHiveNotifier? reelsHiveNotifier;

  @override
  Widget build(BuildContext context) {
    reelsHiveNotifier = context.watch<ReelsHiveNotifier>();
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                      text: "Downloads\t\t",
                      children: [
                        TextSpan(
                            text: "${reelsHiveNotifier?.length} files",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey))
                      ],
                      style: Theme.of(context).textTheme.headline6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
