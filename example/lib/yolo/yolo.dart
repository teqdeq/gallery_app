import 'dart:convert'; // Importing Dart's built-in library for decoding and encoding JSON.
import 'dart:io'; // Provides access to file system paths, directories, and files.
import 'package:file_picker/file_picker.dart'; // A package to pick files from the filesystem.
import 'package:flutter/material.dart'; // Flutter's material design library.
import 'package:flutter/services.dart'; // Services for interacting with platform-specific code.
import 'package:flutter_opencv_plugin/flutter_opencv_plugin.dart'; // Plugin for OpenCV operations.
import 'package:flutter_opencv_plugin_example/yolo/camera_screen.dart'; // Your custom camera screen for YOLO operations.
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart'; // A package to show a modal progress HUD (a loading spinner).
import 'package:path_provider/path_provider.dart'; // A package for finding commonly used locations on the filesystem.

String? srcPath; // Global variable to store the source path of the YOLO model.

class YoloApp extends StatefulWidget {
  const YoloApp({Key? key}) : super(key: key); // Constructor for YoloApp widget.

  @override
  State<YoloApp> createState() => _YoloAppState(); // Creating the state for YoloApp.
}

class _YoloAppState extends State<YoloApp> {
  // State class for YoloApp.

  bool isLoading = false; // Flag to indicate if the app is currently loading something.
  bool isLoadingYoloModel = false; // Flag to indicate if the YOLO model is currently being loaded.

  void startLoading() {
    // Function to set isLoading to true.
    setState(() {
      isLoading = true;
    });
  }

  void stopLoading() {
    // Function to set isLoading to false.
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadYoloModel() async {
    // Asynchronous function to load the YOLO model.
    setState(() {
      isLoadingYoloModel = true; // Indicate that model loading has started.
    });
    try {
      debugPrint("Started loading Yolo model");
      // Attempt to copy the YOLO model assets to a usable directory and load it.
      String srcPath = await copyAsset(assetPath: "models/", dstSubDirName: "yolo_model_files") ?? "";
      await Opencv().loadYolo(srcPath: srcPath, useEmbeddedModel: false); // Load the YOLO model from the copied path.
      debugPrint("Successfully loaded Yolo model");
    } catch (e) {
      debugPrint("$e");
      debugPrint("Failed to load yolo model");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.black,
              content: Text("Failed to load the yolo model"))); // Show an error message if loading fails.
    } finally {
      setState(() {
        isLoadingYoloModel = false; // Indicate that model loading has finished.
      });
    }
  }

  Future<String?> copyAsset({String assetPath = "", String dstSubDirName = ""}) async {
    // Asynchronous function to copy assets from the Flutter project to the device's filesystem.
    final manifestContent = await rootBundle.loadString('AssetManifest.json'); // Load the asset manifest.
    final Map<String, dynamic> manifestMap = json.decode(manifestContent); // Decode the manifest JSON to a map.
    List<String> filePaths = manifestMap.keys.where((String key) => key.startsWith(assetPath)).toList(); // Filter assets by path.

    final String dir = (await getApplicationDocumentsDirectory()).path; // Get the application documents directory path.
    final String subDirPath = '$dir/$dstSubDirName'; // Construct the subdirectory path.
    if (!Directory(subDirPath).existsSync()) {
      Directory(subDirPath).createSync(recursive: true); // Create the subdirectory if it doesn't exist.
    }
    for (var filePath in filePaths) { // For each file in the filtered assets,
      final data = await rootBundle.load(filePath); // Load the asset.
      final bytes = data.buffer.asUint8List(); // Extract the bytes of the file.
      String fileName = filePath.split("/").last; // Get the file name from the asset path.
      File file = File(subDirPath + "/" + fileName); // Create a file object in the target directory.
      await file.writeAsBytes(bytes); // Write the asset bytes to the file in the filesystem.
    }
    return subDirPath; // Return the path to the directory containing the copied assets.
  }

  // Initial setup when the widget is inserted into the widget tree.
  @override
  void initState() {
    super.initState();
    loadYoloModel(); // Calls the loadYoloModel method to start loading the YOLO model asynchronously.
  }

  // Asynchronously picks a directory using the file_picker package.
  Future<String?> pickDirectory() async {
    try {
      final String? result = await FilePicker.platform.getDirectoryPath(); // Opens the directory picker dialog.
      return result; // Returns the path of the selected directory.
    } catch (e) {
      debugPrint('Error picking directory: $e'); // Logs any errors that occur during directory selection.
      return null; // Returns null if an error occurs or if no directory is selected.
    }
  }

  // Builds the UI of the YoloApp widget.
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading, // Controls whether the modal progress HUD should be shown, based on the isLoading flag.
      child: Scaffold(
        body: isLoadingYoloModel == true // Checks if the YOLO model is currently being loaded.
            ? Center(
          child: Container(
            child: CircularProgressIndicator(), // Shows a loading spinner while the model is loading.
          ),
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the column's content vertically.
            children: [
              GestureDetector(
                child: ElevatedButton(
                    onPressed: () async {
                      // Navigates to the CameraScreen widget when the button is pressed.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraScreen()),
                      );
                    },
                    child: Text(
                      "Scan Images", // Button label.
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
