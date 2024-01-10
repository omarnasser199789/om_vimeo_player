import 'package:flutter/material.dart';
import 'package:vimeo_player_example/widgets/video_widget.dart';


void main() {
  runApp(VimeoExample());
}


class VimeoExample extends StatefulWidget {
  const VimeoExample({super.key});

  @override
  State<VimeoExample> createState() => _VimeoExampleState();
}

class _VimeoExampleState extends State<VimeoExample> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(toolbarHeight: 0),
        body: const VideoWidget(videoId: '899877810', accessKey: '',),
      ),
    );
  }
}
