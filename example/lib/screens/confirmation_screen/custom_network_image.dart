import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;

  const CustomNetworkImage({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(20.0), // Define the rounded corner radius
      child: Image.network(
        imageUrl,
        width: double
            .infinity, // Ensures the image stretches to cover the ClipRRect width.
        height: double
            .infinity, // Ensures the image stretches to cover the ClipRRect height.
        fit: BoxFit
            .cover, // Ensures the image maintains aspect ratio and covers the space.
      ),
    );
  }
}
