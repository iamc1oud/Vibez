import 'dart:convert';

import 'package:vibez/_utils/instagram_link_generator.dart';
import 'package:vibez/services/http_service.dart';
import 'package:http/http.dart' as http;

enum POSTTYPE { POST, REEL }

abstract class InstagramRepository with HttpService {
  /// Get the type of media for the provided link
  Future<List<dynamic>> getTypeOfMedia(String link) async {
    var q = getInstaGraphQLLink(link);

    var response = await getRequest(
      uri: q,
    );

    if (response["graphql"]["shortcode_media"]["is_video"]) {
      return [POSTTYPE.REEL, response];
    }
    return [POSTTYPE.POST, null];
  }

  /// Download handler for Instagram videos and reels
  Future<Map<String, dynamic>> downloadReels(String link) async {
    List<dynamic> mediaType = await getTypeOfMedia(link);

    if (mediaType[0] == POSTTYPE.REEL) {
      var graphql = mediaType[1]['graphql'];
      var shortcodeMedia = graphql['shortcode_media'];
      Map<String, dynamic> result = Map();
      result.putIfAbsent(
          "profilePicture", () => shortcodeMedia["owner"]["profile_pic_url"]);
      result.putIfAbsent("username", () => shortcodeMedia["owner"]["username"]);
      result.putIfAbsent(
          "thumbnail_src", () => shortcodeMedia["thumbnail_src"]);
      result.putIfAbsent("link", () => shortcodeMedia["video_url"]);
      result.putIfAbsent(
          "caption",
          () => shortcodeMedia["edge_media_to_caption"]["edges"][0]["node"]
              ["text"]);
      result.putIfAbsent("error", () => false);
      result.putIfAbsent("message", () => "Downloading");
      return result;
    } else {
      return {"error": true, "message": "Download Reels or Videos only"};
    }
  }
}
