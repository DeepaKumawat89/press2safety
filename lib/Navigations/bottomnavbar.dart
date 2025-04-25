// import 'dart:async';
// import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import '../Utils/colors.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
//
//
//
//
// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;
//
//   const CustomBottomNavigationBar({
//     required this.currentIndex,
//     required this.onTap,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             height: 88,
//             decoration: const BoxDecoration(
//               border: Border(
//                 top: BorderSide(width: 1.0, color: Color(0xFFEDEDED)),
//               ),
//             ),
//             child: BottomNavigationBar(
//               currentIndex: currentIndex,
//               onTap: onTap,
//               backgroundColor: Colors.white,
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 5.0),
//                     child: Icon(Icons.location_pin),
//                   ),
//                   label: 'Track Me',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 5.0),
//                     child: Icon(Icons.multitrack_audio),
//                   ),
//                   label: 'Record',
//                 ),
//               ],
//               selectedItemColor: const Color(0xFFD20451),
//               unselectedItemColor: Colors.grey,
//               iconSize: 35,
//             ),
//           ),
//           Positioned(
//               top: -41,
//               left: MediaQuery.of(context).size.width / 2 - 40.5,
//               child: const PanicButtonWidget()
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class PanicButtonWidget extends StatefulWidget {
//   const PanicButtonWidget({super.key});
//
//   @override
//   State<PanicButtonWidget> createState() => _PanicButtonWidgetState();
// }
//
// class _PanicButtonWidgetState extends State<PanicButtonWidget> {
//   bool _buttonPressed = false;
//
//   // Navigate to the TenSecondPanicScreen
//   void _navigateToPanicScreen(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) =>  TenSecondPanicScreen(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _buttonPressed = false;
//         });
//         _navigateToPanicScreen(context); // Navigate to TenSecondPanicScreen
//       },
//       onLongPress: () {
//         setState(() {
//           _buttonPressed = true;
//         });
//         _navigateToPanicScreen(context); // Navigate to TenSecondPanicScreen
//       },
//       onTapDown: (_) {
//         setState(() {
//           _buttonPressed = true;
//         });
//       },
//       onTapUp: (_) {
//         setState(() {
//           _buttonPressed = false;
//         });
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               width: 85,
//               height: 85,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: _buttonPressed
//                     ? AppColors.panicButtonPressed
//                     : AppColors.panicButtonUnpressed,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 5,
//                     blurRadius: 4,
//                     offset: const Offset(0, 0),
//                   ),
//                 ],
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.notifications_on_rounded,
//                   size: 55,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'SOS',
//             style: TextStyle(
//                 fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class TenSecondPanicScreen extends StatefulWidget {
//   @override
//   _TenSecondPanicScreenState createState() => _TenSecondPanicScreenState();
// }
//
// class _TenSecondPanicScreenState extends State<TenSecondPanicScreen> {
//   int countdown = 10;
//   Timer? _timer;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late String userEmail;
//   final String emergencyMessage = "Help! I need assistance."; // Define the message
//
//   @override
//   void initState() {
//     super.initState();
//     userEmail = _auth.currentUser?.email ?? "unknown_user";
//     _startCountdown();
//   }
//
//   // Start the countdown timer
//   void _startCountdown() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (countdown > 1) {
//         setState(() {
//           countdown--;
//         });
//       } else {
//         timer.cancel();
//
//         // Send message
//         await sendMessagesToContacts();
//
//         // Show toast
//         Fluttertoast.showToast(
//           msg: "SMS sent",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//         );
//
//         // Close the screen
//         if (mounted) Navigator.pop(context);
//       }
//     });
//   }
//
//
//   // Function to send emergency messages
//   Future<void> sendMessagesToContacts() async {
//     try {
//       print("Fetching emergency contacts for $userEmail...");
//
//       // Get current location
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       double latitude = position.latitude;
//       double longitude = position.longitude;
//
//       // Get postal address using reverse geocoding
//       List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//       String postalAddress = placemarks.isNotEmpty
//           ? "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}"
//           : "Unknown address";
//
//       // Fetch sender details from /users/{userEmail}
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userEmail)
//           .get();
//
//       String senderName = userDoc['username'] ?? "Unknown";
//       String senderPhone = userDoc['phone'] ?? "Unknown";
//
//       // Fetch contacts
//       QuerySnapshot contactsSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userEmail)
//           .collection('emergency_contacts')
//           .get();
//
//       if (contactsSnapshot.docs.isEmpty) {
//         print("No emergency contacts found!");
//         return;
//       }
//
//       for (var contact in contactsSnapshot.docs) {
//         String phone = contact['phone'];
//
//         DocumentSnapshot phoneDoc = await FirebaseFirestore.instance
//             .collection('userwithphone')
//             .doc(phone)
//             .get();
//
//         if (!phoneDoc.exists || phoneDoc.data() == null) continue;
//
//         Map<String, dynamic> phoneData = phoneDoc.data() as Map<String, dynamic>;
//
//         if (!phoneData.containsKey('email')) continue;
//
//         String recipientEmail = phoneData['email'];
//
//         // Save message in Firestore
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(recipientEmail)
//             .collection('sms')
//             .doc(DateTime.now().millisecondsSinceEpoch.toString())
//             .set({
//           'senderEmail': userEmail,
//           'senderName': senderName,
//           'senderPhone': senderPhone,
//           'message': emergencyMessage,
//           'timestamp': FieldValue.serverTimestamp(),
//           'latitude': latitude,
//           'longitude': longitude,
//           'postalAddress': postalAddress,
//         });
//
//         print("Message successfully stored for $recipientEmail.");
//       }
//
//       print("Emergency messages with sender details sent.");
//     } catch (e) {
//       print("Error while sending messages: $e");
//     }
//   }
//
//
//
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 140),
//             CircleAvatar(
//               radius: 60,
//               backgroundColor: const Color(0xFFEC4A46),
//               child: Text(
//                 '$countdown',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 60,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 100),
//             const Text(
//               'KEEP CALM!',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Poppins',
//                 color: Color(0xFFD20451),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: const Text(
//                 'Within 10 seconds, your close contacts will be alerted of your whereabouts.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 50),
//               child: ElevatedButton(
//                 onPressed: () {
//                   _timer?.cancel();
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: const Color(0xFFD20452),
//                   minimumSize: const Size(200, 70),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 child: const Text(
//                   'STOP SENDING SOS ALERT',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//

import 'dart:async';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../Utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 88,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xFFEDEDED)),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Icon(Icons.location_pin),
                  ),
                  label: 'Track Me',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Icon(Icons.multitrack_audio),
                  ),
                  label: 'Record',
                ),
              ],
              selectedItemColor: const Color(0xFFD20451),
              unselectedItemColor: Colors.grey,
              iconSize: 35,
            ),
          ),
          Positioned(
            top: -41,
            left: MediaQuery.of(context).size.width / 2 - 40.5,
            child: const PanicButtonWidget(),
          ),
        ],
      ),
    );
  }
}

class PanicButtonWidget extends StatefulWidget {
  const PanicButtonWidget({super.key});

  @override
  State<PanicButtonWidget> createState() => _PanicButtonWidgetState();
}

class _PanicButtonWidgetState extends State<PanicButtonWidget> {
  bool _buttonPressed = false;

  void _navigateToPanicScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TenSecondPanicScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _buttonPressed = false);
        _navigateToPanicScreen(context);
      },
      onLongPress: () {
        setState(() => _buttonPressed = true);
        _navigateToPanicScreen(context);
      },
      onTapDown: (_) => setState(() => _buttonPressed = true),
      onTapUp: (_) => setState(() => _buttonPressed = false),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _buttonPressed
                    ? AppColors.panicButtonPressed
                    : AppColors.panicButtonUnpressed,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.notifications_on_rounded,
                  size: 55,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'SOS',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TenSecondPanicScreen extends StatefulWidget {
  @override
  _TenSecondPanicScreenState createState() => _TenSecondPanicScreenState();
}

class _TenSecondPanicScreenState extends State<TenSecondPanicScreen> {
  int countdown = 10;
  Timer? _timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userEmail;
  final String emergencyMessage = "Help! I need assistance.";

  @override
  void initState() {
    super.initState();
    userEmail = _auth.currentUser?.email ?? "unknown_user";
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (countdown > 1) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        await sendMessagesToContacts();
        Fluttertoast.showToast(
          msg: "SOS Alert Sent",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        if (mounted) Navigator.pop(context);
      }
    });
  }

  Future<void> sendMessagesToContacts() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      double latitude = position.latitude;
      double longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      String postalAddress = placemarks.isNotEmpty
          ? "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}"
          : "Unknown address";

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();

      String senderName = userDoc['username'] ?? "Unknown";
      String senderPhone = userDoc['phone'] ?? "Unknown";

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userwithphone')
          .where('linkedTo', isEqualTo: userEmail)
          .get();

      for (var doc in querySnapshot.docs) {
        String recipientEmail = doc['email'];

        await FirebaseFirestore.instance
            .collection('users')
            .doc(recipientEmail)
            .collection('sms')
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          'senderEmail': userEmail,
          'senderName': senderName,
          'senderPhone': senderPhone,
          'message': emergencyMessage,
          'timestamp': FieldValue.serverTimestamp(),
          'latitude': latitude,
          'longitude': longitude,
          'postalAddress': postalAddress,
        });

        print("Message sent to $recipientEmail");
      }
    } catch (e) {
      print("Error while sending messages: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 140),
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFFEC4A46),
              child: Text(
                '$countdown',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 100),
            const Text(
              'KEEP CALM!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFFD20451),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Within 10 seconds, your close contacts will be alerted of your whereabouts.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFD20452),
                  minimumSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'STOP SENDING SOS ALERT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
