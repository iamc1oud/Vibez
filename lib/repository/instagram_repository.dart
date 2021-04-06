import 'dart:convert';

import 'package:vibez/_utils/instagram_link_generator.dart';
import 'package:vibez/services/http_service.dart';
import 'package:http/http.dart' as http;

enum POSTTYPE { POST, REEL }

class InstagramRepository extends HttpService {
  String url = "https://www.instagram.com/";

  Future<POSTTYPE> getTypeOfMedia(String link) async {
    var q = getInstaGraphQLLink(link);
    print(q);
    var response = await getRequest(
      uri: q,
    );

    if (response["graphql"]["shortcode_media"]["is_video"]) {
      return POSTTYPE.REEL;
    }
    return POSTTYPE.POST;
  }

  //Download reels video
  Future<String> downloadReels(String link) async {
    var q = getInstaGraphQLLink(link);
    var downloadURL = await http.get(
      Uri.parse('$q'),
    );
    var data = jsonDecode(downloadURL.body);
    var graphql = data['graphql'];
    var shortcodeMedia = graphql['shortcode_media'];
    var videoUrl = shortcodeMedia['video_url'];
    Map<String, dynamic> result = Map();
    result.putIfAbsent("profilePicture", () => graphql[""]);
    return videoUrl; // return download link
  }
}
