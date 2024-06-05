import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_opencv_plugin/flutter_opencv_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class OpencvService {
  Future<bool> computeFeatures(List<String> imageUrls) async {
    try {
      // Create a temporary directory to store the downloaded images
      final tempDir = await getTemporaryDirectory();

      // Download images from URLs and save them to the temporary directory
      List<String> imagePaths = await Future.wait(imageUrls.map((url) async {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final fileName = url.split('/').last;
          final filePath = '${tempDir.path}/$fileName';
          final file = File(filePath);
          await file.writeAsBytes(bytes);
          return filePath;
        } else {
          throw Exception('Failed to download image: $url');
        }
      }));

      debugPrint("Downloaded images path: ${tempDir.path}");

      // Pass the downloaded image paths to the loadDescriptors method
      final bool result = await Opencv().loadDescriptors(srcPath: tempDir.path);

      return result;
    } catch (e) {
      print('Error computing features: $e');
      return false;
    }
  }
}
