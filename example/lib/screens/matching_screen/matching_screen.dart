import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_opencv_plugin/flutter_opencv_plugin.dart';
// Assuming ImageConfirmationScreen is properly imported
import '../../services/ImageConfirmationScreen.dart';

var cameras;

class CameraScreen extends StatefulWidget {
  CameraScreen();

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  String imagePath = "";
  bool imageTaken = false;
  List<Positioned> cornerAvatars = [];
  List<List<double>> prevCorners = [];
  List<List<double>> cornerPoints = [];
  bool isDetecting = false;
  bool detectedValidFrame = false;
  late CameraImage frame;
  late double roiWidthFactor;
  late double roiHeightFactor;
  double lowerBarLengthFraction = 0.4;
  int detectedSpotCount = 0;
  bool detectedValidSpot = false;
  List<int> prevDetectedSpotCounts = List<int>.filled(5, 0, growable: true);
  int prevDetectedSpotCountIdx = 0;
  int maxIdx = 4;
  bool imageClear = false;
  bool imageInFocus = true;
  String? prediction = null;
  int nullDetectionCount = 0;
  int confidence = 0; /// Help to stabilize things

  void gotoConfirmationScreen(String imageName) {
    // Opencv().close();
    // try {
    //   controller!.stopImageStream();
    // } catch (e) {
    //   debugPrint("$e");
    // }
    // controller?.dispose();

    Future.delayed(Duration(seconds: 3));
    debugPrint("Sending: $imageName to information confirmation screen");
    Navigator.popAndPushNamed(
      context,
      '/image_confirmation_screen',
      arguments: {
        'imageName': imageName,
        'imagePath': imagePath,
      },
    );
  }

  void startCameraStream() {
    controller!.startImageStream((imgFrame) async {
      frame = imgFrame;
      if (isDetecting == true && (frame.sensorExposureTime ?? -1) < 50000000) return;
      if (mounted) {
        setState(() {
          isDetecting = true;
        });
      }
      String? tempPrediction = await Opencv().findBestMatch(frame: frame);
      await Future.delayed(Duration(milliseconds: 600));

      if (mounted && tempPrediction != null && confidence >= 3) {
        gotoConfirmationScreen(tempPrediction);
      }

      if (mounted) {
        setState(() {
          if(tempPrediction == prediction) {
            confidence++;
          } else {
            confidence = 0;
          }
          prediction = tempPrediction;
          nullDetectionCount = (prediction == null) ? nullDetectionCount + 1 : 0;
          isDetecting = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        cameras = await availableCameras();
        debugPrint("There are ${cameras.length} Cameras available");
        final camera = cameras!.first;
        controller = CameraController(camera, ResolutionPreset.medium);
        setState(() {});
      } catch (e) {
        return;
      }
      // initializeCamController();
      controller?.initialize().then((_) {
        controller!.setExposureMode(ExposureMode.auto);
        controller!.setFocusMode(FocusMode.auto);
        debugPrint("Started image Stream");
        startCameraStream();
      });
    });
  }

  Color blackTransparent = Colors.black.withOpacity(0.5);

  @override
  void dispose() {
    Opencv().close();
    try {
      controller!.stopImageStream();
    } catch (e) {
      debugPrint("$e");
    }
    controller?.dispose();
    super.dispose();
  }

  // @override
  // void deactivate() {
  //   debugPrint("Deactivate called");
  //   super.deactivate();
  //   Opencv().close();
  //   try {
  //     controller!.stopImageStream();
  //   } catch (e) {
  //     debugPrint("$e");
  //   }
  //   // controller?.dispose();
  // }

  // @override
  // void activate() {
  //   debugPrint("Actiavte called");
  //   super.activate();
  //   startCameraStream();
  // }

  @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   debugPrint("Did change app life cycle state called");
  //   Opencv().close();
  //   final CameraController? cameraController = controller;
  //
  //   // App state changed before we got the chance to initialize.
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     return;
  //   }
  //
  //   if (state == AppLifecycleState.inactive) {
  //     cameraController.dispose();
  //   } else if (state == AppLifecycleState.resumed) {}
  // }

  Widget changeOrientationMessage() {
    return nullDetectionCount > 3
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Try rotating your phone",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(width: 10),
              Icon(Icons.screen_rotation_sharp, color: Colors.green, size: 20)
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    // controller!.setZoomLevel(1.6);
    double displayHeight = MediaQuery.of(context).size.height;
    double displayWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                width: displayWidth,
                height: displayHeight,
                child: CameraPreview(controller!)),
            Column(
              children: [
                Expanded(
                    child: Container(
                        color: blackTransparent,
                        child: Center(child: changeOrientationMessage()))),
                Expanded(
                  flex: 3,
                  child: Row(children: [
                    Expanded(child: Container(color: blackTransparent)),
                    Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 5,
                                  color: prediction == null
                                      ? Colors.red
                                      : Colors.green)),
                        )),
                    Expanded(
                        child: Container(
                      color: blackTransparent,
                    )),
                  ]),
                ),
                Expanded(
                    child: Container(
                  color: blackTransparent,
                  child: Center(
                      child: Text(prediction ?? "",
                          style: TextStyle(color: Colors.white))),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FeedbackTile extends StatelessWidget {
  const FeedbackTile({
    super.key,
    required this.title,
    required this.state,
  });

  final bool state;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: TextStyle(color: Colors.white)),
        SizedBox(width: 20),
        state == false
            ? Icon(Icons.close, color: Colors.red)
            : Icon(Icons.check, color: Colors.green)
      ],
    );
  }
}
