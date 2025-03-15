// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:press2safety/Auth/Login1.dart';
// import 'package:press2safety/SplashScreen/SplashScreen.dart';
// import 'HomeScreen.dart';
// import 'Test/login.dart';
// import 'package:geolocator/geolocator.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AuthCheck(),
//     );
//   }
// }
//
// class AuthCheck extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   get position => null;
//
//   @override
//   Widget build(BuildContext context) {
//     // Check if a user is already logged in
//     return StreamBuilder<User?>(
//       stream: _auth.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           if (snapshot.hasData) {
//             // User is logged in
//             return HomeScreen(userLocation: position); // Navigate to HomeScreen
//           } else {
//             // User is not logged in
//             return LoginScreen(); // Navigate to LoginPage
//           }
//         }
//         // If the auth state is not yet available, show a loading indicator
//         return Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:press2safety/Auth/Login1.dart';
import 'package:press2safety/SplashScreen/SplashScreen.dart';
import 'HomeScreen.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is logged in, check and get location permission
            return FutureBuilder<Position>(
              future: _getUserLocation(),
              builder: (context, locationSnapshot) {
                if (locationSnapshot.connectionState == ConnectionState.done) {
                  if (locationSnapshot.hasData) {
                    // If location permission granted, pass the location to HomeScreen
                    return HomeScreen(userLocation: locationSnapshot.data!);
                  } else {
                    // Location permission denied or error occurred
                    return Center(child: Text('Location permission is required.'));
                  }
                } else {
                  // Waiting for location permission result
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            // User is not logged in
            return SplashScreen();
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // Method to get user location and handle permission
  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    // If permission is granted, get the current position
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    }

    throw Exception('Location permission not granted.');
  }
}

