// // import 'dart:developer';
// // import 'dart:io';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/foundation.dart';
// // import '../../../utils/formatters/formatters.dart';
// //
// // final FirebaseStorage storage = FirebaseStorage.instance;
// //
// // class StorageService
// // {
// //   static Future<void> uploadAudio(Uint8List audioData, String path) async
// //   {
// //     try
// //     {
// //       Reference ref = storage.ref().child(path);
// //       UploadTask uploadUserAudio = ref.putData(audioData);
// //       await uploadUserAudio;
// //     }
// //     catch (e)
// //     {
// //       log("Failed to upload audio: $e");
// //     }
// //   }
// //
// //   static Future<void> uploadImage(String filePath, String storagePath) async
// //   {
// //     try
// //     {
// //       final storageRef = FirebaseStorage.instance.ref().child(storagePath);
// //       final uploadTask = await storageRef.putFile(File(filePath));
// //       final imageUrl = await uploadTask.ref.getDownloadURL();
// //       if (kDebugMode) {
// //         print('Image uploaded to Firebase Storage: $imageUrl');
// //       }
// //     }
// //     catch (e)
// //     {
// //       if (kDebugMode) {
// //         print('Error uploading image to Firebase Storage: $e');
// //       }
// //     }
// //   }
// //
// //   // -- Extract folders date-wise from storage
// //   Future<List<String>> listDateFolders(String uid) async {
// //     List<String> dateFolders = [];
// //     try {
// //       ListResult result = await storage.ref('recordings/images/$uid').listAll();
// //       for (var prefix in result.prefixes) {
// //         dateFolders.add(prefix.name);
// //       }
// //     } catch (e) {
// //       if (e is FirebaseException) {
// //         log('FirebaseException: ${e.message}');
// //         log('Error code: ${e.code}');
// //       } else {
// //         log('Unexpected error: $e');
// //       }
// //     }
// //     return dateFolders;
// //   }
// //
// //
// //   // -- extract image src, date and time from the storage
// //   Future<List<ImageData>> listImagesForEachDate(String uid, String date) async {
// //     List<ImageData> imageDatas = [];
// //     try
// //     {
// //       ListResult result = await storage.ref('recordings/images/$uid/$date/').listAll();
// //       for (var item in result.items)
// //       {
// //         String imageUrl = await item.getDownloadURL();
// //         String imageDate = extractTimeFromPath(item.fullPath);
// //         imageDatas.add(ImageData(imageUrl, imageDate));
// //       }
// //     }
// //     catch (e)
// //     {
// //       if (kDebugMode) {
// //         print('Error listing image URLs: $e');
// //       }
// //     }
// //     return imageDatas;
// //   }
// //
// //   // -- Extracts image time from the image name
// //   String extractTimeFromPath(String filename)
// //   {
// //     String pathWithoutImageExtension = filename.split('.').first; // remove
// //     // .jpg extension
// //     List<String> parts = pathWithoutImageExtension.split(' '); // Split by space to separate date and time
// //     String time = Formatters.formatTime(parts.last); // Take the last part which is the time
// //     return time;
// //   }
// // }
// //
// // // -- class that contains necessary data for showing image list on
// // // recording_details page
// // class ImageData
// // {
// //   final String imageUrl;
// //   final String date;
// //
// //   ImageData(this.imageUrl,this.date);
// // }
//
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
//
// final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
// class StorageService {
//
//   // -- Upload Audio to Firestore as Base64
//   static Future<void> uploadAudio(Uint8List audioData, String userId) async {
//     try {
//       // Convert audio to Base64
//       String base64Audio = base64Encode(audioData);
//
//       // Store the audio metadata (Base64 data) in Firestore
//       await firestore.collection('audioRecordings').add({
//         'userId': userId,
//         'audioBase64': base64Audio,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       if (kDebugMode) {
//         print('Audio uploaded and metadata stored in Firestore');
//       }
//     } catch (e) {
//       log("Failed to upload audio: $e");
//     }
//   }
//
//   // -- Upload Image to Firestore as Base64
//   static Future<void> uploadImage(String filePath, String userId) async {
//     try {
//       // Read image file as bytes
//       File imageFile = File(filePath);
//       Uint8List imageBytes = await imageFile.readAsBytes();
//
//       // Convert image to Base64
//       String base64Image = base64Encode(imageBytes);
//
//       // Store the image metadata (Base64 data) in Firestore
//       await firestore.collection('images').add({
//         'userId': userId,
//         'imageBase64': base64Image,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       if (kDebugMode) {
//         print('Image uploaded and metadata stored in Firestore');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error uploading image to Firestore: $e');
//       }
//     }
//   }
//
//   // -- Extract folders date-wise from Firestore (using metadata)
//   Future<List<String>> listDateFolders(String uid) async {
//     List<String> dateFolders = [];
//     try {
//       QuerySnapshot result = await firestore.collection('images')
//           .where('userId', isEqualTo: uid)
//           .get();
//
//       // Extract unique dates from the metadata (timestamp)
//       for (var doc in result.docs) {
//         String timestamp = doc['timestamp'].toDate().toString().split(' ')[0]; // Extract date only
//         if (!dateFolders.contains(timestamp)) {
//           dateFolders.add(timestamp);
//         }
//       }
//     } catch (e) {
//       if (e is FirebaseException) {
//         log('FirebaseException: ${e.message}');
//         log('Error code: ${e.code}');
//       } else {
//         log('Unexpected error: $e');
//       }
//     }
//     return dateFolders;
//   }
//
//   // -- Extract image metadata for each date from Firestore
//   Future<List<ImageData>> listImagesForEachDate(String uid, String date) async {
//     List<ImageData> imageDatas = [];
//     try {
//       QuerySnapshot result = await firestore.collection('images')
//           .where('userId', isEqualTo: uid)
//           .get();
//
//       // Match the images by date
//       for (var doc in result.docs) {
//         String base64Image = doc['imageBase64'];
//         DateTime timestamp = doc['timestamp'].toDate();
//         String imageDate = timestamp.toString().split(' ')[0]; // Extract date
//         if (imageDate == date) {
//           imageDatas.add(ImageData(base64Image, imageDate));
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error listing image metadata from Firestore: $e');
//       }
//     }
//     return imageDatas;
//   }
//
//   // -- Decode the base64 image data to display it// Ensure this import is present
//
// // -- Decode the base64 image data to display it
// //   static Image decodeBase64Image(String base64Image) {
// //     try {
// //       // Decode base64 and return Image widget
// //       Uint8List bytes = base64Decode(base64Image);
// //       return Image.memory(bytes);
// //     } catch (e) {
// //       log("Failed to decode base64 image: $e");
// //       return Image.asset('assets/images/placeholder.png');  // Placeholder in case of error
// //     }
// //   }
//
//   // -- Decode the base64 audio data (you can store or play it later)
//   static Uint8List decodeBase64Audio(String base64Audio) {
//     try {
//       return base64Decode(base64Audio); // Decode and return audio data
//     } catch (e) {
//       log("Failed to decode base64 audio: $e");
//       return Uint8List(0); // Return empty data in case of error
//     }
//   }
// }
//
// // -- Class to hold the image data, including Base64 and timestamp
// class ImageData {
//   final String base64Image;
//   final String date;
//
//   ImageData(this.base64Image, this.date);
// }
//

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class StorageService {
  // -- Upload Audio to Firestore as Base64
  static Future<void> uploadAudio(Uint8List audioData, String userId) async {
    try {
      String base64Audio = base64Encode(audioData);

      await firestore.collection('audioRecordings').add({
        'userId': userId,
        'audioBase64': base64Audio,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Audio uploaded and metadata stored in Firestore');
      }
    } catch (e) {
      log("Failed to upload audio: $e");
    }
  }

  // -- Upload Image to Firestore as Base64
  static Future<void> uploadImage(String filePath, String userId) async {
    try {
      File imageFile = File(filePath);
      Uint8List imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      await firestore.collection('images').add({
        'userId': userId,
        'imageBase64': base64Image,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Image uploaded and metadata stored in Firestore');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image to Firestore: $e');
      }
    }
  }

  // -- List images for a user on a specific date
  static Future<List<ImageData>> listImagesForDate(String userId, String date) async {
    List<ImageData> imageList = [];
    try {
      // Get the start of the day and the end of the day
      DateTime startOfDay = DateTime.parse(date + ' 00:00:00');
      DateTime endOfDay = DateTime.parse(date + ' 23:59:59');

      QuerySnapshot result = await firestore
          .collection('images')
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThanOrEqualTo: endOfDay)
          .get();

      for (var doc in result.docs) {
        String base64Image = doc['imageBase64'];
        DateTime timestamp = doc['timestamp'].toDate();
        String imageDate = timestamp.toString().split(' ')[0];

        if (imageDate == date) {
          imageList.add(ImageData(base64Image, imageDate));
        }
      }
    } catch (e) {
      log('Error retrieving images: $e');
    }
    return imageList;
  }
}

// -- Model classes to hold Image and Audio data
class ImageData {
  final String base64Image;
  final String date;

  ImageData(this.base64Image, this.date);
}

class AudioData {
  final String base64Audio;
  final DateTime timestamp;

  AudioData(this.base64Audio, this.timestamp);
}



