import 'package:flutter/material.dart';
import 'package:flutter_opencv_plugin/flutter_opencv_plugin.dart'; // Importing the OpenCV plugin for Flutter.

// AddApp StatefulWidget allows for dynamic content that can change over time.
class AddApp extends StatefulWidget {
  const AddApp({Key? key}) : super(key: key); // Constructor for the widget accepting an optional Key.

  @override
  State<AddApp> createState() => _AddAppState(); // Creating the state for this StatefulWidget.
}

class _AddAppState extends State<AddApp> {
  // TextEditingControllers to control the text fields for number input.
  TextEditingController num1Controller = TextEditingController();
  TextEditingController num2Controller = TextEditingController();

  double? sum; // Variable to store the result of addition.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Flutter Opencv Example Application") // AppBar title.
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0), // Padding for the body content.
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centering content vertically.
                children: [
                  SizedBox(height: 10),
                  Text("Enter num1: "), // Label for the first number input.
                  TextField(controller: num1Controller,), // TextField for the first number input.
                  SizedBox(height: 10),
                  Text("Enter num2: "), // Label for the second number input.
                  TextField(controller: num2Controller,), // TextField for the second number input.
                  SizedBox(height: 10),
                  Text("$sum"), // Displaying the result of the addition.
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () async{
                        // On button press, perform addition using the OpenCV plugin.
                        double? sumTemp = await Opencv().addNumbers(num1: double.parse(num1Controller.text), num2: double.parse(num2Controller.text));
                        setState(() {
                          // Update the state with the new sum.
                          sum = sumTemp;
                        });
                      },
                      child: Text("Add") // Button text.
                  )
                ],
              )
          ),
        )
    );
  }
}
