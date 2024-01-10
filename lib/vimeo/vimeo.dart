import 'package:om_vimeo_player/vimeo/data/remote/auth_api_service.dart';
import 'package:om_vimeo_player/vimeo/data/remote/none_auth_api_service.dart';
import 'package:om_vimeo_player/vimeo/vimeo_video.dart';

/// Vimeo Class provides functions to get vimeo data.
class Vimeo {
  final String? videoId;
  final String? accessKey;

  Vimeo({
    this.videoId,
    this.accessKey,
  })  : assert(videoId != null && accessKey != null);

  factory Vimeo.fromUrl(Uri url, {String? accessKey}) {
    String? vId;
    vId = url.pathSegments.last;

    return Vimeo(
      videoId: vId,
      accessKey: accessKey,
    );
  }
}

extension ExtensionVimeo on Vimeo {
  /// get video meta data from vimeo server.
  Future<dynamic> get load async {
    if (videoId != null) {
      if (accessKey?.isEmpty ?? true) {
        return _videoWithoutAuth;
      }
      return _videoWithAuth;
    }

    return _liveStreaming;
  }

  /// get private video meta data from vimeo server
  Future<dynamic> get _videoWithAuth async {
    try {
      var res = await AuthApiService()
          .loadByVideoId(accessKey: accessKey!, videoId: videoId!);
      return await VimeoVideo.fromJsonVideoWithAuth(
          videoId: videoId!,
          accessKey: accessKey!,
          json: (res as Map<String, dynamic>));
    } catch (e) {
      return e;
    }
  }

  /// get public video meta data from vimeo server
  Future<dynamic> get _videoWithoutAuth async {
    try {
      var res = await NoneAuthApiService().getVimeoData(id: videoId!);
      return await VimeoVideo.fromJsonVideoWithoutAuth(
          res as Map<String, dynamic>);
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> get _liveStreaming async {
    try {
      var res = await AuthApiService().loadByEventId(accessKey: accessKey!);
      return VimeoVideo.fromJsonLiveEvent(res);
    } catch (e) {
      return e;
    }
  }
}
