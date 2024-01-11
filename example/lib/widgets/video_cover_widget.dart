import 'package:flutter/material.dart';

class VideoCaverWidget extends StatelessWidget {
  const VideoCaverWidget({Key? key, required this.onTap, required this.height,required this.coverUrl}) : super(key: key);
  final Function () onTap;
  final double height;
  final String coverUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            height: height,
            width: double.infinity,
            child: Image.network(coverUrl)
        ),
        GestureDetector(
          onTap:onTap,
          child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(200),
                  border: Border.all(color: Theme.of(context).primaryColor,width: 3)
              ),
              child: Icon(Icons.play_arrow_outlined,
                size: 30,
                color: Theme.of(context).primaryColor,)),
        ),
      ],
    );
  }
}
