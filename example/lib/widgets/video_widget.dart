import 'package:flutter/material.dart';
import 'package:om_vimeo_player/om_vimeo_player.dart';
import 'error_video_widget.dart';
import 'loading_video_widget.dart';


class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key, required this.videoId, required this.accessKey});
  final String videoId;
  final String accessKey;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VimeoVideo? vimeoVideo;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late ValueNotifier<Object?> _vimeoNotifier;

  @override
  void initState() {
    super.initState();
    _vimeoNotifier = ValueNotifier(null);
    initVimeo();
  }

  Future<void> initVimeo() async {
    var res = await Vimeo(
      videoId: widget.videoId,
      accessKey: widget.accessKey,
    ).load;

    if (res is VimeoError) {
      _vimeoNotifier.value = res;
    } else if (res is VimeoVideo) {
      vimeoVideo = res;
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(vimeoVideo!.videoUrl.toString()),
      );
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
      );
      _vimeoNotifier.value = vimeoVideo;
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
    return ValueListenableBuilder<Object?>(
      valueListenable: _vimeoNotifier,
      builder: (context, value, child) {
        if (value == null) {
          return const LoadingVideoWidget();
        } else if (value is VimeoError) {
          return  const ErrorVideoWidget();
        } else if (value is VimeoVideo) {
          return VimeoPlayer(
            videoController: _chewieController,
          );
        } else {
          return Container(); // Placeholder widget, replace with appropriate widget
        }
      },
    );
  }
}
