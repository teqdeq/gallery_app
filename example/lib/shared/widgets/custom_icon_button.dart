import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onPressed;
  final bool isCurrentScreen; // Added to indicate if this is the current screen

  final double size;

  const CustomIconButton({
    Key? key,
    required this.icon,
    this.color = const Color.fromARGB(100, 44, 53, 62),
    this.iconColor = const Color.fromARGB(20, 138, 138, 138),
    required this.onPressed,
    this.size = 30.0,
    this.isCurrentScreen = false, // Default set to false
  }) : super(key: key);

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    // Add a distinctive style for the current screen button
    final currentScreenStyle = widget.isCurrentScreen ? BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.lightBlueAccent, // A highlighted color
      boxShadow: [
        BoxShadow(
          color: Colors.blueAccent.shade100.withOpacity(0.5),
          spreadRadius: 4,
          blurRadius: 10,
          offset: Offset(0, 4), // changes position of shadow
        ),
      ],
    ) : BoxDecoration();
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: math.sin(_animation.value),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.color, // Button color
          borderRadius:
              BorderRadius.circular(widget.size / 2), // Circular shape
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35), // Shadow color
              offset: Offset(2, 2), // Shadow position
              blurRadius: 1, // Shadow blur
              spreadRadius: 1, // Shadow spread radius
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.7), // Opposite shadow color
              offset: Offset(-1, -1), // Opposite shadow position
              blurRadius: 10, // Opposite shadow blur
              spreadRadius: 2, // Opposite shadow spread radius
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(widget.icon),
          color: widget.iconColor,
          iconSize: widget.size,
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
