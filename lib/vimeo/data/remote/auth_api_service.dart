import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:om_vimeo_player/vimeo/video_error.dart';

/// Getting data of private video from vimeo server.
class AuthApiService {
  Map<String, String> headers = {"content-type": "text/json"};
  Map<String, String> cookies = {};

  /// id : video id
  /// accessKey : your vimeo account access key.
  Future<dynamic> loadVimeoVideoById({required String videoId, required String accessKey}) async {
    Uri uri = Uri.parse("https://api.vimeo.com/videos/$videoId");
    var res = await http.get(uri, headers: {"Authorization": "Bearer $accessKey"});

    if (res.statusCode != 200) {
      throw VideoError(
          error: res.reasonPhrase,
          developerMessage: "Please check your video id",
          errorCode: res.statusCode);
    }
    return jsonDecode(res.body);
  }


  ///AWS
  Future<dynamic> loadAWSVideoById({required String signCookieURL, required String jwt}) async {
    var client = http.Client();

    final res = await client.get(Uri.parse(signCookieURL), headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    if (res.statusCode != 200) {
      throw VideoError(
          error: res.reasonPhrase,
          developerMessage: "Please check your video URL or JWT",
          errorCode: res.statusCode);
    }
    await updateCookie(res);

    return headers;
  }

  Future<dynamic> updateCookie(http.Response response) async {
    String allSetCookie = response.headers['set-cookie']!;
    var setCookies = allSetCookie.split(',');

    for (var setCookie in setCookies) {
      var cookies = setCookie.split(';');
      for (var cookie in cookies) {
        await _setCookies(cookie);
      }
    }
    headers['cookie'] = await _generateCookieHeader();
  }

  Future<dynamic> _setCookies(String rawCookie) async {
    if (rawCookie.isNotEmpty) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        cookies[key] = value;
      }
    }
  }

  Future<String> _generateCookieHeader() async {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.isNotEmpty) {
        cookie += ";";
      }
      cookie += "$key=${cookies[key]!}";
    }
    return cookie;
  }

}
