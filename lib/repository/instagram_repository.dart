import 'dart:convert';

import 'package:vibez/_utils/instagram_link_generator.dart';
import 'package:vibez/services/http_service.dart';
import 'package:http/http.dart' as http;

enum POSTTYPE { POST, REEL }

class InstagramRepository with HttpService {
  Future<POSTTYPE> getTypeOfMedia(String link) async {
    var q = getInstaGraphQLLink(link);

    var response = await getRequest(
      uri: q,
    );
    print(response["graphql"]["shortcode_media"]["is_video"]);

    if (response["graphql"]["shortcode_media"]["is_video"]) {
      print(response);
      return POSTTYPE.REEL;
    }
    return POSTTYPE.POST;
  }

  //Download reels video
  Future<Map<String, dynamic>> downloadReels(String link) async {
    var q = getInstaGraphQLLink(link);
    var downloadURL = await http.get(
      Uri.parse('$q'),
    );

    var data = jsonDecode(downloadURL.body);
    var graphql = data['graphql'];
    var shortcodeMedia = graphql['shortcode_media'];
    Map<String, dynamic> result = Map();
    result.putIfAbsent(
        "profilePicture", () => shortcodeMedia["owner"]["profile_pic_url"]);
    result.putIfAbsent("username", () => shortcodeMedia["owner"]["username"]);
    result.putIfAbsent("thumbnail_src", () => shortcodeMedia["thumbnail_src"]);
    result.putIfAbsent("link", () => shortcodeMedia["video_url"]);
    return result;
  }
}
