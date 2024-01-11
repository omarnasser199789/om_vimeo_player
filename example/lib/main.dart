import 'package:flutter/material.dart';
import 'package:vimeo_player_example/widgets/video_widget.dart';


void main() {
  runApp(const VimeoExample());
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
        // body: const VideoWidget(videoId: '899877810', accessKey: 'd83d133237fd6aa8c78760307719c021',
        //   videoCover: 'https://s3.eu-west-1.amazonaws.com/course.emasteryacademy.com/p1rfc6m8b7nwy1zw3q015yevv511lzpsermw54jh5tz9q88h37.png',),

        body: const VideoWidget(
          awsVideoURL: "https://media.emasteryacademy.com/media/cftsu977cxs41xjh2nnok62kk.m3u8",
          signCookieURL: 'https://v1.emasteryacademy.com/v1/signcookie',
          jwt: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiby5uYXNzZXJAZWx0Z2NjLmNvbSIsImlkZW4iOiIzMTY2NiIsInN1YiI6IjMwZDhmNjRmLThkYzYtNDE0ZS04MDQ1LTQzODVlZWMyYWQ2NiIsImdyb3VwIjoiNyIsImRlcGFydG1lbnRJZCI6IiIsImNvbXBhbnlJZCI6IiIsImJzdXBlciI6IiIsIm5iZiI6MTcwNDk3Mzc1MCwiZXhwIjoxNzA0OTc3MDUwLCJpYXQiOjE3MDQ5NzM3NTB9.xt7ZpvEztEljrilVL-HJ05WdY04Xmbqal_ZQtuZqEMQ',
          videoCover: 'https://s3.eu-west-1.amazonaws.com/course.emasteryacademy.com/p1rfc6m8b7nwy1zw3q015yevv511lzpsermw54jh5tz9q88h37.png',),
      ),
    );
  }
}
