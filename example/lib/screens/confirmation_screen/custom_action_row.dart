import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_icon_button.dart'; // Adjust the path as necessary

class CustomActionRow extends StatelessWidget {
  final VoidCallback onDeclinePressed;
  final VoidCallback onAcceptPressed;

  CustomActionRow({
    required this.onDeclinePressed,
    required this.onAcceptPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomIconButton(
          icon: Icons.close, // Assuming you have icons for these actions
          iconColor: Colors.white,
          color: Color.fromARGB(255, 69, 17, 13), // Color for decline action
          size: 30.0,
          onPressed: onDeclinePressed,
        ),
        CustomIconButton(
          icon: Icons.check, // Assuming you have icons for these actions
          iconColor: Colors.white,
          color:
              const Color.fromARGB(255, 26, 61, 28), // Color for accept action
          size: 30.0,
          onPressed: onAcceptPressed,
        ),
      ],
    );
  }
}
