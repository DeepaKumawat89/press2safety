// import 'dart:async'; // Import this for asynchronous initialization
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Navigations/appbar.dart';
// import '../Services/Storage_service.dart';
// import '../Utils/HelperFunction.dart';
// import '../Utils/formaters.dart';
// import 'RecordDetails.dart';
//
// AppHelperFunctions appHelperFunctions = AppHelperFunctions();
//
// class ViewRecordingsHistory extends StatefulWidget {
//   const ViewRecordingsHistory({super.key, String? userID});
//
//   @override
//   State<ViewRecordingsHistory> createState() => _ViewRecordingHistoryState();
// }
//
// class _ViewRecordingHistoryState extends State<ViewRecordingsHistory> {
//   final StorageService _storageService = StorageService();
//   List<String> dateFolders = [];
//   bool isLoading = true;
//   late String userID;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeUserID();
//   }
//
//   Future<void> _initializeUserID() async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final storedUserID = prefs.getString('phoneNumber');
//       if (storedUserID != null) {
//         setState(() {
//           userID = storedUserID;
//         });
//         await fetchDateFolders();
//       } else {
//         // Handle case where userID is null
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error initializing userID: $e');
//       }
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> fetchDateFolders() async {
//     if (userID.isNotEmpty) {
//       try {
//         List<String> folders = await _storageService.listDateFolders(userID);
//         setState(() {
//           dateFolders = folders;
//           isLoading = false;
//         });
//       } catch (e) {
//         if (kDebugMode) {
//           print('Error fetching date folders: $e');
//         }
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } else {
//       // Handle case where userID is empty
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar:  CustomAppBar(onEditProfile: () {  },),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 15.0, top: 3.0, right: 15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back_ios,
//                     color: Color(0xFF263238),
//                     size: 15,
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const Text(
//                   'Recording History',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 3.0),
//             const Text(
//               'View the captured images and audio of the recorded events.',
//               style: TextStyle(
//                 fontSize: 11,
//                 fontFamily: 'Poppins',
//                 color: Colors.grey,
//               ),
//             ),
//             const Divider(color: Color(0xFFEDEDED)),
//             const SizedBox(height: 13),
//             isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Expanded(
//               child: ListView.builder(
//                 itemCount: dateFolders.length,
//                 itemBuilder: (context, index) {
//                   final dateFolder = dateFolders[index];
//                   return RecordedHistoryTile(
//                     date: dateFolder,
//                     userID: userID,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RecordedHistoryTile extends StatelessWidget {
//   final String date;
//   final String userID;
//
//   const RecordedHistoryTile({
//     super.key,
//     required this.date,
//     required this.userID,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedDate = Formatters.formatDateString(date);
//
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ListTile(
//         leading: const Icon(Icons.video_library_rounded),
//         title: Text(
//           'Recorded on $formattedDate',
//           style: const TextStyle(
//             fontSize: 13,
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => RecordingDetails(
//                 uid: userID,
//                 date: date,
//               ),
//             ),
//           );
//         },
//         trailing: const Icon(
//           Icons.arrow_forward_ios,
//           color: Color(0xFF263238),
//           size: 13,
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../Navigations/appbar.dart';
import '../Services/Storage_service.dart';
import '../Utils/HelperFunction.dart';
import '../Utils/colors.dart';
import '../Utils/formaters.dart';
import 'RecordDetails.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

class RecordingDetails extends StatelessWidget {
  final String? uid;
  final String date;

  const RecordingDetails({super.key, this.uid, required this.date});

  @override
  Widget build(BuildContext context) {
    String formattedDate = Formatters.formatDateString(date);

    return FutureBuilder<List<ImageData>>(
      future: StorageService.listImagesForDate(uid!, date), // Correct method name
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(onEditProfile: () {}),
            body: Center(
              child: appHelperFunctions.appLoader(context),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: CustomAppBar(onEditProfile: () {}),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(onEditProfile: () {}),
            body: const Center(
              child: Text('No images found for this date.'),
            ),
          );
        } else {
          List<ImageData> imageDatas = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(onEditProfile: () {}),
            body: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 3.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF263238),
                          size: 15,
                        ),
                        onPressed: () => appHelperFunctions.goBack(context),
                      ),
                      Text(
                        'Record History of $formattedDate',
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.dividerPrimary),
                  const SizedBox(height: 10),
                  Text(
                    'Photos (${imageDatas.length})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: imageDatas
                          .map((data) => PhotoWidget(data: data))
                          .toList(),
                    ),
                  ),
                  const Divider(color: Color(0xFFEDEDED)),
                  const SizedBox(height: 16),
                  const Text(
                    'Audios',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 350,
                    child: VoiceMessageView(
                      controller: VoiceController(
                        audioSrc: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                        onComplete: () {},
                        onPause: () {},
                        onPlaying: () {},
                        onError: (err) {},
                        maxDuration: const Duration(minutes: 30),
                        isFile: false,
                        noiseCount: 50,
                      ),
                      size: 50.0,
                      innerPadding: 3,
                      playIcon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      pauseIcon: const Icon(
                        Icons.pause_rounded,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      activeSliderColor: AppColors.secondary,
                      circlesTextStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      circlesColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

// -- Display each photo fetched from Firestore
class PhotoWidget extends StatelessWidget {
  final ImageData data;

  const PhotoWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appHelperFunctions.goToScreenAndComeBack(
            context, ZoomableImagePage(imageSrc: data.base64Image));
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: MemoryImage(base64Decode(data.base64Image)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.date,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 10),
          ),
        ],
      ),
    );
  }
}
