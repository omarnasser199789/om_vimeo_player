import 'package:flutter/material.dart';

class LoadingVideoWidget extends StatelessWidget {
  const LoadingVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
