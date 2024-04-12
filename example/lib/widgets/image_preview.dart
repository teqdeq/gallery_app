import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String imageUrl;

  ImagePreview({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl, fit: BoxFit.cover);
  }
}
