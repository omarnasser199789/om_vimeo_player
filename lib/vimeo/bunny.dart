import 'bunny_video.dart';

/// Vimeo Class provides functions to get vimeo data.
class Bunny {
  final String url;
  final String password;
  Bunny({
    required this.url,
    required this.password,
  });
}

extension ExtensionBunny on Bunny {
  /// get video meta data from vimeo server.
  Future<dynamic> get load async {
    return _bunnyVideoWithAuth;
  }

  /// get private video meta data from AWS server
  Future<dynamic> get _bunnyVideoWithAuth async {
    try {
      var headers =   {
        "AccessKey": password,
        "Content-Type": "application/json"
      };
      return  BunnyVideo( headers: headers, url: url);

    } catch (e) {
      return e;
    }
  }

}
