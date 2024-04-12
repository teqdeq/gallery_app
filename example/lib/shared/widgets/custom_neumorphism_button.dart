import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class CustomNeumorphicButton extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  const CustomNeumorphicButton({
    Key? key,
    required this.icon,
    this.iconColor = Colors.green,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomNeumorphicButtonState createState() => _CustomNeumorphicButtonState();
}

class _CustomNeumorphicButtonState extends State<CustomNeumorphicButton> {
  bool isElevated = true;

  @override
  Widget build(BuildContext context) {
    Offset distance = isElevated ? const Offset(5, 5) : const Offset(10, 10);
    double blur = isElevated ? 15.0 : 20.0;
    return GestureDetector(
      onTap: () {
        setState(() {
          isElevated = !isElevated;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isElevated = true;
        });
      },
      onTapDown: (_) {
        setState(() {
          isElevated = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          isElevated = true;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500]!,
              offset: distance,
              blurRadius: blur,
              spreadRadius: 1,
              inset: isElevated,
            ),
            BoxShadow(
              color: Colors.white,
              offset: -distance,
              blurRadius: blur,
              spreadRadius: 1,
              inset: isElevated,
            )
          ],
        ),
        child: Icon(
          widget.icon,
          size: 25,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
