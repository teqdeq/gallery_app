import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_app/global_vars.dart';

class ImageConfirmationScreen extends StatefulWidget {
  // final String imageName = args?['imageName'] ?? 'No Image';
  // final String imagePath = args?['imagePath'] ?? 'No Path';
  // final String imageName;
  // final String imagePath;

  // const ImageConfirmationScreen({Key? key, required this.imageName, required this.imagePath}) : super(key: key);

  @override
  State<ImageConfirmationScreen> createState() => _ImageConfirmationScreenState();
}

class _ImageConfirmationScreenState extends State<ImageConfirmationScreen> {
  late String imageName;
  late String imagePath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;

    if (args != null) {
      imageName = args['imageName'] ?? 'No Image';
      imagePath = args['imagePath'] ?? 'No Path';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(
                    File(imageName2Path[imageName]??"")
                  ),
                )
              ),

            ),
            // Display the image (placeholder for your image display logic)
            Text(imageName), // Display the image name
            // Buttons for "Not Correct" and "Correct"
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/matching_screen'),
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
      ),
    );
  }
}
