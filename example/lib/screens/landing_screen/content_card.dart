import 'package:flutter/material.dart';
import 'dart:math';
import '../../shared/widgets/custom_navigation_button_bar.dart'; // Adjust the import path as needed

class ContentCard extends StatefulWidget {
  final String color;
  final Color altColor;
  final String title;
  final String subtitle;

  ContentCard({
    required this.color,
    this.title = "",
    required this.subtitle,
    required this.altColor,
  }) : super();

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var time = DateTime.now().millisecondsSinceEpoch / 2000;
    var scaleX = 1.2 + sin(time) * .05;
    var scaleY = 1.2 + cos(time) * .07;
    var offsetY = 20 + cos(time) * 20;
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        Transform(
          transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
          child: Transform.translate(
            offset: Offset(-(scaleX - 1) / 2 * size.width,
                -(scaleY - 1) / 2 * size.height + offsetY),
            child: Image.asset('assets/images_nav/Bg-${widget.color}.png',
                fit: BoxFit.cover),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 75.0, bottom: 25.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Image.asset(
                        'assets/images_nav/Illustration-${widget.color}.png',
                        fit: BoxFit.contain),
                  ),
                ),
                Container(
                    height: 14,
                    child: Image.asset(
                        'assets/images_nav/Slider-${widget.color}.png')),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: _buildBottomContent(),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBottomContent() {
    // Assuming the route names are '/', '/matching_screen', and '/collection_screen'
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.2,
            fontSize: 30.0,
            fontFamily: 'DMSerifDisplay',
            color: Colors.white,
          ),
        ),
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
            fontFamily: 'OpenSans',
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20), // Spacing between text and buttons
        CustomNavigationButtonBar(
          onHomePressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          onCameraPressed: () {
            Navigator.pushNamed(context, '/matching_screen');
          },
          onCollectionPressed: () {
            Navigator.pushNamed(context, '/collection_screen');
          },
          currentRouteName: currentRoute,
        ),
      ],
    );
  }
}
