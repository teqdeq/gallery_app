import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import '../../shared/widgets/custom_navigation_button_bar.dart'; // Ensure correct path
import '../../screens/confirmation_screen/confirmation_screen.dart';

class MatchingScreen extends StatefulWidget {
  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  double _currentZoomLevel = 1.0;
  final double _maxZoomLevel = 2.0; // Adjust according to your needs

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras![0], ResolutionPreset.medium);
    await _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> _updateZoomLevel(double zoomLevel) async {
    final double newZoomLevel = zoomLevel.clamp(1.0, _maxZoomLevel);
    try {
      await _controller!.setZoomLevel(newZoomLevel);
      setState(() {
        _currentZoomLevel = newZoomLevel;
      });
    } catch (e) {
      print("Zoom level update failed: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen camera preview
          CameraPreview(_controller!),
          // Gesture detector for zoom functionality
          Positioned.fill(
            child: GestureDetector(
              onScaleUpdate: (ScaleUpdateDetails details) {
                double newZoomLevel = _currentZoomLevel * details.scale;
                _updateZoomLevel(newZoomLevel);
              },
            ),
          ),
          // Overlay custom navigation buttons on the camera view
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavigationButtonBar(
              onHomePressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              onCameraPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                        imageId: "precious_jewels_by_the_3d6569e4"),
                  ),
                );
              },
              onCollectionPressed: () {
                Navigator.pushNamed(context, '/collection_screen');
              },
              currentRouteName: ModalRoute.of(context)?.settings.name ?? '',
            ),
          ),
        ],
      ),
    );
  }
}
