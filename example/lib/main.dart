import 'package:flutter/material.dart';
import 'package:om_vimeo_player/om_vimeo_player.dart';

void main() {
  runApp(VimeoExample());
}


class VimeoExample extends StatefulWidget {
  const VimeoExample({super.key});

  @override
  State<VimeoExample> createState() => _VimeoExampleState();
}

class _VimeoExampleState extends State<VimeoExample> {
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
    print("Start INIT......");
    var res = await Vimeo(
      videoId: '899877810',
      eventId: '',
      accessKey: "d83d133237fd6aa8c78760307719c021",
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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(toolbarHeight: 0),
        body: ValueListenableBuilder<Object?>(
          valueListenable: _vimeoNotifier,
          builder: (context, value, child) {
            if (value == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (value is VimeoError) {
              return const Center(
                child: Text('Error'),
              );
            } else if (value is VimeoVideo) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: VimeoPlayer(
                  videoController: _chewieController,
                ),
              );
            } else {
              return Container(); // Placeholder widget, replace with appropriate widget
            }
          },
        ),
      ),
    );
  }
}
