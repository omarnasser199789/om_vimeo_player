import 'package:om_vimeo_player/vimeo/data/remote/auth_api_service.dart';

import 'asw_video.dart';

/// Vimeo Class provides functions to get vimeo data.
class Aws {
  final String signCookieURL;
  final String jwt;
  Aws({
    required this.signCookieURL,
    required this.jwt,
  });
}

extension ExtensionAws on Aws {
  /// get video meta data from vimeo server.
  Future<dynamic> get load async {
    return _awsVideoWithAuth;
  }

  /// get private video meta data from AWS server
  Future<dynamic> get _awsVideoWithAuth async {
    try {
      var headers = await AuthApiService().loadAWSVideoById(signCookieURL: signCookieURL, jwt: jwt);
      return  AwsVideo( headers: headers);

    } catch (e) {
      return e;
    }
  }

}
