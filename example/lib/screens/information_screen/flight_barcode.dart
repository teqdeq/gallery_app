import 'package:flutter/material.dart';

import 'main.dart';

class FlightBarcode extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: MaterialButton(
            child:
                Image.asset('assets/images_nav/barcode.png', package: App.pkg),
            onPressed: () {
              print('Button was pressed');
            }),
      ));
}
