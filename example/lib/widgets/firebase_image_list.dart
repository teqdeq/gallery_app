import 'package:flutter/material.dart';
import '../services/firebase_storage_service.dart';
import '../services/opencv_service.dart';
import 'image_preview.dart';

class FirebaseImageList extends StatefulWidget {
  @override
  _FirebaseImageListState createState() => _FirebaseImageListState();
}

class _FirebaseImageListState extends State<FirebaseImageList> {
  List<String> imageUrls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchImagesAndComputeFeatures();
  }

  Future<void> fetchImagesAndComputeFeatures() async {
    setState(() {
      _isLoading = true;
    });
    final firebaseStorageService = FirebaseStorageService();
    final urls = await firebaseStorageService.getImageUrls();
    setState(() {
      imageUrls = urls;
    });
    await computeFeatures();
    if (mounted) {
      Navigator.pushReplacementNamed(
          context, '/landing_screen'); // Assuming the route name is correct
    }
  }

  Future<void> computeFeatures() async {
    final opencvService = OpencvService();
    await opencvService.computeFeatures(imageUrls);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return ImagePreview(imageUrl: imageUrls[index]);
            },
          );
  }
}
