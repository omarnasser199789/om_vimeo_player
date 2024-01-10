[![Star on GitHub](https://img.shields.io/github/stars/kauemurakami/app_version_update.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/omarnasser199789/om_vimeo_player)

Retrieve version and url for local app update against store app
Android and iOS


## [Omar Nasser](https://github.com/omarnasser199789)
<img src="https://avatars.githubusercontent.com/u/22509641?s=96&v=4" alt="Omar Nasser" width="50" height="50" style="border-radius: 50%;">

[![GitHub](https://img.shields.io/badge/GitHub-gray)](https://github.com/omarnasser199789)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue)](https://www.linkedin.com/in/omar-mouhamad-nasser/)
[![Portfolio](https://img.shields.io/badge/Portfolio-orange)](https://omar-nasser-portfolio.web.app/#/)

# om_vimeo_player plugin

vimeo_player_flutter plugin provides vimeo player Flutter widget based on the webview_flutter plugin.

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  om_vimeo_player: ^0.0.1
```

## Usage

Then you just have to import the package with

```dart
import 'package:om_vimeo_player/om_vimeo_player.dart';
```

## Example

```dart
   import 'package:flutter/material.dart';
import 'package:om_vimeo_player/om_vimeo_player.dart';

void main() {
  runApp(VimeoExample());
}

class VimeoExample extends StatefulWidget {
  @override
  _VimeoExampleState createState() => _VimeoExampleState();
}

class _VimeoExampleState extends State<VimeoExample> {
  VimeoVideo? vimeoVideo;
  BetterPlayerController? controller;

  Future<dynamic> initVimeo() async {//1561517022
    var res = await Vimeo(
      videoId: '899877810',
      eventId: '',
      accessKey: "",
    ).load;

    if (res is VimeoError) {
      return res;
    }

    bool autoPlay = false;
    if (res is VimeoVideo) {
      vimeoVideo = res;
      controller = BetterPlayerController(
        BetterPlayerConfiguration(autoPlay: res.isLive || autoPlay),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          vimeoVideo!.videoUrl.toString(),
          liveStream: res.isLive,
        ),
      );
    }

    return vimeoVideo;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose(forceDispose: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: Stack(alignment: Alignment.topCenter, children: [
            FutureBuilder<dynamic>(
              future: initVimeo(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade700)),
                      child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                              child:
                              Center(child: CircularProgressIndicator()))));
                }

                if (snapshot.data is VimeoError) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade700)),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            "${(snapshot.data as VimeoError).developerMessage}" +
                                "\n${(snapshot.data as VimeoError).errorCode ?? ""}" +
                                "\n\n${(snapshot.data as VimeoError).error}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return VimeoPlayer(
                  vimeoVideo: vimeoVideo!,
                  videoController: controller!,
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 48,
                color: Colors.red.withOpacity(0.3),
                alignment: Alignment.center,
                child: Text(
                  'Vimeo Player Example',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ])),
    );
  }
}

```
