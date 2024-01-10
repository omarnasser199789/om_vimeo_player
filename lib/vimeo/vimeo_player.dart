
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chewie/chewie.dart';


class VimeoPlayer extends StatefulWidget {
  final ChewieController videoController;
  const VimeoPlayer({super.key, required this.videoController});

  @override
  State<VimeoPlayer> createState() => _VimeoPlayerState();
}

class _VimeoPlayerState extends State<VimeoPlayer> {
  @override
  void dispose() {
    super.dispose();
    widget.videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:  widget.videoController.aspectRatio!,
      child: Chewie(
          controller: widget.videoController
      ),
    );
  }
}


