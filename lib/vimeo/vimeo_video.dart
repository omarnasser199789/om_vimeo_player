import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:om_vimeo_player/vimeo/video_error.dart';

class VimeoVideo {
  final bool liveEvent;
  int? width;
  int? height;
  final List<_VimeoQualityFile?> sources;

  VimeoVideo({
    this.liveEvent = false,
    this.width,
    this.height,
    required this.sources,
  });

  static Future<VimeoVideo> fromJsonVideoWithAuth({
    required String videoId,
    required String accessKey,
    required Map<String, dynamic> json,
  }) async {
    if (json.keys.contains("error")) {
      throw VideoError.fromJsonAuth(json);
    }

    if (json['embed']?['badges']['live']['streaming'] ?? false) {
      Uri uri =
      Uri.parse("https://api.vimeo.com/me/videos/$videoId/m3u8_playback");
      var response =
      await http.get(uri, headers: {"Authorization": "Bearer $accessKey"});
      var body = jsonDecode(response.body);

      return VimeoVideo(
          width: json['width'],
          height: json['height'],
          liveEvent: true,
          sources: [
            _VimeoQualityFile(
              quality: _VimeoQualityFile.hls,
              file: VimeoSource(
                height: json['height'],
                width: json['width'],
                url: Uri.parse(body['m3u8_playback_url']),
              ),
            )
          ]);
    }

    var jsonFiles = (json['files']) as List<dynamic>;
    List<_VimeoQualityFile?> files = List<_VimeoQualityFile?>.from(
        jsonFiles.map<_VimeoQualityFile?>((element) {
          if (element['quality'] != null &&
              element['quality'] != _VimeoQualityFile.hls) {
            return _VimeoQualityFile(
              quality: element['quality'],
              file: VimeoSource(
                height: element['height'],
                width: element['width'],
                fps: element['fps'] is double
                    ? element['fps']
                    : (element['fps'] as int).toDouble(),
                url: Uri.tryParse(element['link'] as String)!,
              ),
            );
          }
          return null;
        })).toList();
    return VimeoVideo(
      liveEvent: json['embed']['badges']['live']['streaming'],
      width: json['width'],
      height: json['height'],
      sources: files,
    );
  }

}

extension ExtensionVimeoVideo on VimeoVideo {
  Uri? get videoUrl {
    return defaultVideo?.url;
  }

  int get size {
    return width! > height! ? width! : height!;
  }

  double get ratio => width! / height!;

  Map<String, String> get resolutions {
    Map<String, String> ret = {};

    for (var q in sources) {
      if (q == null) {
        continue;
      }
      ret.addAll({q.quality: q.file.url.toString()});
    }

    return ret;
  }

  bool get isLive => liveEvent;

  VimeoSource? get defaultVideo {
    VimeoSource? ret = sources.first?.file;
    for (var file in sources) {
      if (file?.file.size == size) {
        ret = file?.file;
        break;
      }
    }
    return ret;
  }
}

class VimeoSource {
  final int? height;
  final int? width;
  final double? fps;
  final Uri url;

  VimeoSource({
    this.height,
    this.width,
    this.fps,
    required this.url,
  });

  factory VimeoSource.fromJson({required bool isLive, required dynamic json}) {
    return VimeoSource(
      height: json['height'],
      width: json['width'],
      fps: json['fps'],
      url: Uri.parse(json['url']),
    );
  }

  int? get size => (height == null || width == null)
      ? null
      : height! > width!
      ? height
      : width;
}

class _VimeoQualityFile {
  static const String hls = "hls";

  final String quality;
  final VimeoSource file;

  _VimeoQualityFile({
    required this.quality,
    required this.file,
  });
}
