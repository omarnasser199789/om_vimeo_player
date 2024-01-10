import 'dart:async';

import 'package:flutter/services.dart';

export 'package:video_player/video_player.dart';
export 'package:chewie/chewie.dart';
export 'package:om_vimeo_player/vimeo/vimeo.dart';
export 'package:om_vimeo_player/vimeo/vimeo_error.dart';
export 'package:om_vimeo_player/vimeo/vimeo_player.dart';
export 'package:om_vimeo_player/vimeo/vimeo_video.dart';

class OmVimeoPlayer {
  static const MethodChannel _channel = MethodChannel('remedi_vimeo_player');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
