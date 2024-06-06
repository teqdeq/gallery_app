import 'package:flutter/material.dart';
import 'package:gallery_app/services/ImageConfirmationScreen.dart';
import 'package:shared/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/loading_screen/home_screen.dart';
import 'package:flutter_opencv_plugin/flutter_opencv_plugin.dart'; // Import the OpenCV plugin for Flutter.
import '/screens/landing_screen/demo.dart'; // Assuming this is where DemoScreen is located
import '/screens/matching_screen/matching_screen.dart';
import '/screens/collection_screen/collection_screen.dart';
import '/screens/confirmation_screen/confirmation_screen.dart';
import '/screens/information_screen/demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Opencv().initialize(newAppName: "MatcherApp"); // Initialize the OpenCV plugin with your app name.
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String _pkg = "gooey_edge";
  static String? get pkg =>
      _pkg; // This getter is static and should be accessible

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gooey Edge Demo',
      theme: ThemeData(
          // Define your app's theme here
          ),
      initialRoute: '/landing_screen', // Define the initial route
      routes: {
        '/': (context) => HomeScreen(),
        '/demo': (context) =>
            TicketFoldDemo(), // Assuming you want to navigate here directly sometimes
        '/matching_screen': (context) =>
            CameraScreen(), // Replace with your matching screen widget
        '/collection_screen': (context) =>
            CollectionScreen(), // Replace with your collection screen widget
        '/confirmation_screen': (context) => ConfirmationScreen(imageId: "precious_jewels_by_the_3d6569e4"), // Replace with your confirmation screen widget
        '/image_confirmation_screen' : (context) => ImageConfirmationScreen (),
        '/loading_screen': (context) =>
            HomeScreen(), // Replace with your loading screen screen widget
        '/landing_screen': (context) => GooeyEdgeDemo(title: 'Gooey Edge Demo'),
      },
    );
  }
}
