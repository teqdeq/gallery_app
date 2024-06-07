import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_opencv_plugin/flutter_opencv_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../global_vars.dart';

class OpencvService {
  Future<bool> computeFeatures(List<Map<String, String>> imagesData) async {
    try {
      // Create a temporary directory to store the downloaded images
      final tempDir = await getTemporaryDirectory();

      List<String> imagePaths = [];

      for(var imageData in imagesData) {
        final String url = imageData["image_url"]!;
        Uri? uri = Uri.tryParse(url);
        if(uri == null || url == "" || url == null) continue;
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          // final fileName = url.split('/').last;
          final String ext = getFileExtension(url);
          //Todo: might have to change the structure of this filename
          final filename = imageData["artist_name"]! + "." + ext;
          debugPrint("***Downloaded $filename");
          final filePath = '${tempDir.path}/$filename';

          /// Store for future use
          imageName2Path.addAll({
            imageData["artist_name"]??"" : filePath
          });

          final file = File(filePath);
          await file.writeAsBytes(bytes);
          imagePaths.add(filePath);
          // return filePath;
        } else {
          debugPrint('Failed to download image: $url');
        }
      }

      // Download images from URLs and save them to the temporary directory
      // List<String> imagePaths = await Future.wait(imagesData.map((imageData) async {
      //   final String url = imageData["image_file"]!;
      //   final response = await http.get(Uri.tryParse(url));
      //   if (response.statusCode == 200) {
      //     final bytes = response.bodyBytes;
      //     // final fileName = url.split('/').last;
      //     final String ext = getFileExtension(url);
      //     //Todo: might have to change the structure of this filename
      //     final filename = imageData["artist_name"]! + "." + ext;
      //     debugPrint("***Downloaded $filename");
      //     final filePath = '${tempDir.path}/$filename';
      //     final file = File(filePath);
      //     await file.writeAsBytes(bytes);
      //     return filePath;
      //   } else {
      //     throw Exception('Failed to download image: $url');
      //   }
      // }));

      debugPrint("Downloaded images path: ${tempDir.path}");

      // Pass the downloaded image paths to the loadDescriptors method
      final bool result = await Opencv().loadDescriptors(srcPath: tempDir.path);

      if(result == true){
        debugPrint("Successfully loaded descriptors");
      } else {
        debugPrint("Failed to load descriptors");
      }

      return result;
    } catch (e) {
      print('Error computing features: $e');
      return false;
    }
  }

  String getFileExtension(String url) {
    // Parse the URL
    Uri uri = Uri.parse(url);

    // Extract the path from the URL
    String path = uri.path;

    // Find the position of the last '.' in the path
    int dotIndex = path.lastIndexOf('.');

    // If a '.' is found, extract the extension
    if (dotIndex != -1 && dotIndex < path.length - 1) {
      return path.substring(dotIndex + 1);
    }

    // Return an empty string if no extension is found
    return '';
  }
}
