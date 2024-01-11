import 'package:om_vimeo_player/vimeo/data/remote/auth_api_service.dart';
import 'package:om_vimeo_player/vimeo/vimeo_video.dart';

/// Vimeo Class provides functions to get vimeo data.
class Vimeo {
  final String videoId;
  final String accessKey;
  Vimeo({
    required this.videoId,
    required this.accessKey,
  });
}

extension ExtensionVimeo on Vimeo {
  /// get video meta data from vimeo server.
  Future<dynamic> get load async {
      return _vimeoVideoWithAuth;
  }

  /// get private video meta data from vimeo server
  Future<dynamic> get _vimeoVideoWithAuth async {
    try {
      var res = await AuthApiService().loadVimeoVideoById(accessKey: accessKey, videoId: videoId);
      return await VimeoVideo.fromJsonVideoWithAuth(
          videoId: videoId,
          accessKey: accessKey,
          json: (res as Map<String, dynamic>));
    } catch (e) {
      return e;
    }
  }
}
