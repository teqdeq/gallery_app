import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../services/firebase_storage_service.dart';
import '../services/opencv_service.dart';
import 'firebase_service.dart';


class LocalStorageService {
  // List<String> imageUrls = [];
  // bool _isLoading = false;
  // bool featuresSuccessfullyComputed = false;


  static Future<bool> initialize() async{
    bool isSuccessfull = await clearStartupDirectories();
    if(isSuccessfull == true)  {
      bool featuresSuccessfullyComputed = await fetchImagesAndComputeFeatures();
      if(featuresSuccessfullyComputed) {
        debugPrint("**** Successfully computed features ****");
      } else {
        debugPrint("**** Failed to compute features ****");
      }
      return featuresSuccessfullyComputed;
    } else {
      return false;
    }
  }

  static Future<bool> clearStartupDirectories() async {
    try {
      final tempDir = await getTemporaryDirectory();
      await clearDirectory(tempDir);
      debugPrint("Successfully cleared local images' directory");
      // final appDir = await getApplicationDocumentsDirectory();
      // final descriptorDir = Directory('${appDir.path}/descriptors');
      // if (await descriptorDir.exists()) {
      //   await clearDirectory(descriptorDir);
      // }
      return true;
    }catch(e) {
      debugPrint("$e");
      debugPrint("Failed to clear local image directory");
      return false;
    }

  }

  static Future<void> clearDirectory(Directory dir) async {
    try {
      final files = dir.listSync(); // List all files and folders
      for (final file in files) {
        await file.delete(
            recursive: true); // Recursively delete files and folders
      }
      print('Directory cleared: ${dir.path}');
    } catch (e) {
      print('Error clearing directory: ${e.toString()}');
    }
  }

  static Future<bool> fetchImagesAndComputeFeatures() async {
    // setState(() {
    //   _isLoading = true;
    // });
    try {
      final firebaseService = FirebaseService();
      final List<Map<String, String>> imagesData = await firebaseService.getAllImagesData();
      debugPrint("Successfully retrieved imagesData from firebase");
      // imageUrls = urls;
      await computeFeatures(imagesData);
      debugPrint("Successfully fetched images and computed features");
      return true;
    }catch(e) {
      debugPrint("Error fetching images and computing features");
      debugPrint("$e");
      return false;
    }


    // if (mounted) {
    //   Navigator.pushReplacementNamed(
    //       context, '/landing_screen'); // Assuming the route name is correct
    // }
  }

  static Future<void> computeFeatures(List<Map<String, String>> imagesData) async {
    final opencvService = OpencvService();
    await opencvService.computeFeatures(imagesData);
  }

}
