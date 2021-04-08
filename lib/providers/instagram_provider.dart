import 'package:flutter/cupertino.dart';
import 'package:vibez/repository/instagram_repository.dart';

class InstagramProvider extends InstagramRepository with ChangeNotifier {
  bool _isDownloadingReel = false;
  bool get isDownloadingReel => _isDownloadingReel;
  set setIsDownloadingReel(bool val) {
    _isDownloadingReel = val;
    notifyListeners();
  }

  Map<String, dynamic>? _data;
  Map<String, dynamic>? get data => _data;

  /// Method to download reel
  Future<void> downloadReel(String link) async {
    setIsDownloadingReel = true;
    _data = await downloadReels(link);
    notifyListeners();
    setIsDownloadingReel = false;
  }
}
