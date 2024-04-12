import 'package:flutter/material.dart';
import 'custom_action_row.dart';
import 'custom_network_image.dart';
// Ensure this import path matches your project structure
import '../information_screen/demo.dart';

class ConfirmationScreen extends StatefulWidget {
  final String imageId;

  ConfirmationScreen({Key? key, required this.imageId}) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  String imageUrl =
      'https://imgv3.fotor.com/images/slider-image/A-clear-close-up-photo-of-a-woman.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Transform.scale(
                scale: 0.8, // Reduce the size of the image by 20%
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomNetworkImage(imageUrl: imageUrl),
                ),
              ),
            ),
            SizedBox(height: 20), // Adds space above the informational text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Is this the right image?',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40), // Increase this size if more space is needed
            CustomActionRow(
              onDeclinePressed: () => print("Decline pressed"),
              onAcceptPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TicketFoldDemo()),
              ),
            ),
            SizedBox(
                height:
                    60), // Adds a little space at the bottom for better spacing
          ],
        ),
      ),
    );
  }
}
