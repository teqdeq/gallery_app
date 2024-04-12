import 'package:flutter/material.dart';
import '../../widgets/firebase_image_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Matching'),
      ),
      body: FirebaseImageList(),
    );
  }
}
