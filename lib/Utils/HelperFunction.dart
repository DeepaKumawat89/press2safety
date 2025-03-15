// import 'dart:math';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
//
// import '../HomeScreen.dart';
// import 'colors.dart';
//
// class AppHelperFunctions
// {
//   static String extractTodayDate()
//   {
//     return DateTime.now().toString().split(' ')[0];
//   }
//
//   static String extractTodayTime()
//   {
//     return DateTime.now().toString().split(' ')[1].split('.')[0];
//   }
//
//   static int generateSafeCodeForRescue()
//   {
//     final random = Random();
//     final code = 1000 + random.nextInt(9000);
//     return code;
//   }
//
//   void goToScreenAndComeBack(BuildContext context, Widget nextScreen)
//   {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => nextScreen),
//     );
//   }
//
//   void goToScreenAndDoNotComeBack(BuildContext context, Widget nextScreen)
//   {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => nextScreen),
//     );
//   }
//
//   void goBack(BuildContext context)
//   {
//     Navigator.pop(
//         context
//     );
//   }
//
//   void goToHomeScreen(BuildContext context, User user, Position userLocation) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => HomeScreen(userLocation: userLocation),
//       ),
//     );
//   }
//
//
//
//   static void showAlert(BuildContext context, String title, String message)
//   {
//     showDialog(
//         context: context,
//         builder: (BuildContext context)
//         {
//           return AlertDialog(
//             title: Text(title),
//             content: Text(message),
//             actions: [
//               TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('Close')
//               )
//             ],
//           );
//         }
//     );
//   }
//
//   Widget appLoader(BuildContext context)
//   {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: LoadingAnimationWidget.flickr(
//           leftDotColor: AppColors.logoPrimary,
//           rightDotColor: AppColors.logoSecondary,
//           size: 50.0,
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'colors.dart';
import '../HomeScreen.dart';

class AppHelperFunctions {
  static String extractTodayDate() {
    return DateTime.now().toString().split(' ')[0];
  }

  static String extractTodayTime() {
    return DateTime.now().toString().split(' ')[1].split('.')[0];
  }

  static int generateSafeCodeForRescue() {
    final random = Random();
    final code = 1000 + random.nextInt(9000);
    return code;
  }

  void goToScreenAndComeBack(BuildContext context, Widget nextScreen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  void goToScreenAndDoNotComeBack(BuildContext context, Widget nextScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void goToHomeScreen(BuildContext context, User user, Position userLocation) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(userLocation: userLocation),
      ),
    );
  }

  static void showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  Widget appLoader(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: AppColors.logoPrimary,
          rightDotColor: AppColors.logoSecondary,
          size: 50.0,
        ),
      ),
    );
  }

  /// New method for uploading audio to Cloudinary
  Future<void> uploadAudioToCloudinary(Uint8List audioBytes, String userEmail) async {
    final String cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dqcdrgblc/upload';
    final String uploadPreset = 'upload'; // Replace with your actual upload preset

    try {
      // Create a temporary file
      final directory = await getTemporaryDirectory();  // You will need to import 'package:path_provider/path_provider.dart' for this.
      final file = File('${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await file.writeAsBytes(audioBytes);
      String filePath = file.path;

      // Sanitize the email
      String sanitizedEmail = userEmail.replaceAll('@', '_').replaceAll('.', '_');
      String filePathForUser = 'user_audio/$sanitizedEmail/${DateTime.now().millisecondsSinceEpoch}.mp3';

      // Create the request
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset;
      request.fields['resource_type'] = 'raw'; // Specify resource_type as 'raw' for audio files
      request.fields['public_id'] = filePathForUser; // Set a custom public_id

      // Add the file to the request
      var fileToUpload = await http.MultipartFile.fromPath('file', filePath);
      request.files.add(fileToUpload);

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        print('Upload successful');
        final responseData = await response.stream.toBytes();
        final result = json.decode(String.fromCharCodes(responseData));
        print('File URL: ${result['secure_url']}');
      } else {
        print('Upload failed: ${response.statusCode}');
        final responseBody = await response.stream.toBytes();
        print('Response body: ${String.fromCharCodes(responseBody)}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}