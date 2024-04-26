// import 'package:flutter/material.dart';
// import 'package:/shared/env.dart';
// import '/screens/landing_screen/demo.dart'; // Assuming this is where DemoScreen is located
// import '/screens/matching_screen/matching_screen.dart';
// import '/screens/collection_screen/collection_screen.dart';
// import '/screens/confirmation_screen/confirmation_screen.dart';
// import '/screens/information_screen/demo.dart';
//
// void main() => runApp(App());
//
// class App extends StatelessWidget {
//   static String _pkg = "gooey_edge";
//   static String? get pkg => Env.getPackage(_pkg);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gooey Edge Demo',
//       theme: ThemeData(
//           // Define your app's theme here
//           ),
//       initialRoute: '/', // Define the initial route
//       routes: {
//         '/': (context) => GooeyEdgeDemo(title: 'Gooey Edge Demo'),
//         '/demo': (context) =>
//             TicketFoldDemo(), // Assuming you want to navigate here directly sometimes
//         '/matching_screen': (context) =>
//             MatchingScreen(), // Replace with your matching screen widget
//         '/collection_screen': (context) =>
//             CollectionScreen(), // Replace with your collection screen widget
//         '/confirmation_screen': (context) => ConfirmationScreen(
//             imageId:
//                 "precious_jewels_by_the_3d6569e4"), // Replace with your confirmation screen widget
//         '/loading_screen': (context) => HomeScreen(),
//       },
//     );
//   }
// }
