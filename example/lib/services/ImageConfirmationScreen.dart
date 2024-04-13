import 'package:flutter/material.dart';

class ImageConfirmationScreen extends StatelessWidget {
  final String imageName;
  final String imagePath;

  const ImageConfirmationScreen({Key? key, required this.imageName, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Image'),
      ),
      body: Column(
        children: [
          // Display the image (placeholder for your image display logic)
          Text(imageName), // Display the image name
          // Buttons for "Not Correct" and "Correct"
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Not Correct'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to ArtisDetailScreen with the necessary image details
            },
            child: Text('Correct'),
          ),
        ],
      ),
    );
  }
}
