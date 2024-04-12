import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_icon_button.dart';

class CustomNavigationButtonBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onCameraPressed;
  final VoidCallback onCollectionPressed;
  final String currentRouteName;

  CustomNavigationButtonBar({
    required this.onHomePressed,
    required this.onCameraPressed,
    required this.onCollectionPressed,
    required this.currentRouteName,
  });

  @override
  Widget build(BuildContext context) {
    Color getButtonColor(String routeName) {
      // Adjust color based on the current route
      return currentRouteName == routeName
          ? Color.fromARGB(255, 33, 56, 76)
          : Colors.blue;
    }

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Center the buttons horizontally
      children: <Widget>[
        CustomIconButton(
          icon: Icons.home, // Icon for the home/landing screen
          iconColor: Colors.white,
          color: getButtonColor('/'), // Highlight if current screen
          size: 30.0,
          onPressed: onHomePressed,
        ),
        SizedBox(width: 50), // Spacing between the buttons
        CustomIconButton(
          icon: Icons.camera_alt, // Icon for the camera/matching screen
          iconColor: Colors.white,
          color:
              getButtonColor('/matching_screen'), // Highlight if current screen
          size: 30.0,
          onPressed: onCameraPressed,
        ),
        SizedBox(width: 50), // Spacing between the buttons
        CustomIconButton(
          icon: Icons.collections, // Icon for the collection screen
          iconColor: Colors.white,
          color: getButtonColor(
              '/collection_screen'), // Highlight if current screen
          size: 30.0,
          onPressed: onCollectionPressed,
        ),
      ],
    );
  }
}
