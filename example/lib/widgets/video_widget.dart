import 'package:flutter/material.dart';
import 'package:om_vimeo_player/om_vimeo_player.dart';
import 'package:om_vimeo_player/vimeo/asw_video.dart';
import 'package:vimeo_player_example/widgets/video_cover_widget.dart';
import 'error_video_widget.dart';
import 'loading_video_widget.dart';


class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key, this.videoId, this.accessKey, this.awsVideoURL, this.jwt, this.signCookieURL, required this.videoCover});

  /// Vimeo Server
  final String? videoId;
  final String? accessKey;

  /// AWS Server
  final String? signCookieURL;
  final String? jwt;
  final String? awsVideoURL;

  final String videoCover;
  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VimeoVideo? vimeoVideo;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late ValueNotifier<int?> _vimeoNotifier;
  late final ValueNotifier<bool> _playVideoNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _vimeoNotifier = ValueNotifier(null);
    initVimeo();
  }

  Future<void> initVimeo() async {
    dynamic res;
    if(widget.videoId!=null && widget.accessKey!=null){
       res = await Vimeo(
        videoId: widget.videoId!,
        accessKey: widget.accessKey!,
      ).load;
    }else if(widget.signCookieURL!=null && widget.jwt!=null){
      res = await Aws(
        signCookieURL: widget.signCookieURL!,
        jwt: widget.jwt!
      ).load;
    }


    if (res is VideoError) {
      _vimeoNotifier.value = 400;
    } else if (res is VimeoVideo) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        // httpHeaders: {
        //   'content-type': 'text/json',
        //   'cookie': 'CloudFront-Policy=eyJTdGF0ZW1lbnQiOiBbeyJSZXNvdXJjZSI6Imh0dHBzOi8vbWVkaWEuZW1hc3RlcnlhY2FkZW15LmNvbS8qIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzA1Mzk5MjI4fSwiRGF0ZUdyZWF0ZXJUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3MDQ5NjcyMjh9fX1dfQ__;domain=https://emasteryacademy.com;CloudFront-Key-Pair-Id=KGXG8EAB3WPDH;CloudFront-Signature=VAnsvlq~qeCQEHt2~wIzzP4GYX4uf8o9uRpl~sh1mNtGtLlBJ~xKKZVG0ZwcW4lSFp2yfKYDneeou1pPYAc3Eox-mcowecBKBZ9TAXsdkvsLzzaA9xZrFCSvW2vd-BbUqA~8T-zpFddBFXj46EGygpHh6H1lKZ2AOsGpBnhIQ7-KjKKtHClnwli6IOYi22o0-QKry2GWsRbMZh-VEWYv0ehwZjCuAUq4sYtLNt0rjewFpeFh9WGso3Cfet~nofBpz5yVfxZRdmS4bbp7DFjSvM5PK1KUALquDU4HnLOCzlT5kg~j3aVydsL0ZkzxVWoj~FYvgWTpAj-KbJ6mGLTr5A__',
        // },
        // Uri.parse("https://media.emasteryacademy.com/media/cftsu977cxs41xjh2nnok62kk.m3u8"),
        Uri.parse(vimeoVideo!.videoUrl.toString()),
      );
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: false,
        autoInitialize: true,
        looping: false,
      );
      _vimeoNotifier.value = 200;
    }else if (res is AwsVideo) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        httpHeaders: res.headers,
        Uri.parse(widget.awsVideoURL!),
      );
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: false,
        autoInitialize: true,
        looping: false,
      );
      _vimeoNotifier.value = 200;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _vimeoNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _playVideoNotifier,
        builder: (context, playVideoValue, child) {
          if(playVideoValue){
            return ValueListenableBuilder<Object?>(
              valueListenable: _vimeoNotifier,
              builder: (context, value, child) {
                if (value == null) {
                  return const LoadingVideoWidget();
                } else if (value == 400) {
                  return  const ErrorVideoWidget();
                } else if (value == 200) {
                  return VimeoPlayer(
                    videoController: _chewieController,
                  );
                } else {
                  return Container(); // Placeholder widget, replace with appropriate widget
                }
              },
            );
          }else{
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoCaverWidget(onTap: () {
                _videoPlayerController.play();
                _playVideoNotifier.value=true;
              }, height: 300, coverUrl: widget.videoCover,),
            );
          }
        }
    );
  }
}
