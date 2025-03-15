import 'dart:async';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Utils/colors.dart';



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
              child: const PanicButtonWidget()
          ),
        ],
      ),
    );
  }
}

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
//   void _handlePanicButtonPress() {
//     // Perform navigation to TenSecondPanicScreen
//     // Navigator.of(context).push(
//     //   MaterialPageRoute(builder: (_) => TenSecondPanicScreen()),
//     // );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) {
//         setState(() {
//           _buttonPressed = true;
//         });
//       },
//       onTapUp: (_) {
//         setState(() {
//           _buttonPressed = false;
//         });
//         _handlePanicButtonPress();
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


class PanicButtonWidget extends StatefulWidget {
  const PanicButtonWidget({super.key});

  @override
  State<PanicButtonWidget> createState() => _PanicButtonWidgetState();
}

class _PanicButtonWidgetState extends State<PanicButtonWidget> {
  bool _buttonPressed = false;

  // Navigate to the TenSecondPanicScreen
  void _navigateToPanicScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>  TenSecondPanicScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _buttonPressed = false;
        });
        _navigateToPanicScreen(context); // Navigate to TenSecondPanicScreen
      },
      onLongPress: () {
        setState(() {
          _buttonPressed = true;
        });
        _navigateToPanicScreen(context); // Navigate to TenSecondPanicScreen
      },
      onTapDown: (_) {
        setState(() {
          _buttonPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _buttonPressed = false;
        });
      },
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
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// class TenSecondPanicScreen extends StatelessWidget {
//   const TenSecondPanicScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     int countdown = 10;
//
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 140),
//             RippleAnimation(
//               repeat: true,
//               duration: const Duration(milliseconds: 900),
//               ripplesCount: 10,
//               color: const Color(0xFFF8BDBB),
//               minRadius: 100,
//               size: const Size(170, 170),
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: const Color(0xFFEC4A46),
//                 child: Text(
//                   '$countdown',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 80,
//                     fontWeight: FontWeight.w600,
//                   ),
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
//               child: RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   text: 'Within ',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: 'Poppins',
//                     color: Colors.black,
//                   ),
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: '10 seconds,',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' your ',
//                     ),
//                     TextSpan(
//                       text: 'close contacts',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' will be alerted of your whereabouts.',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 60),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 'Press the button below to stop SOS alert.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 50),
//               child: ElevatedButton(
//                 onPressed: () {
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


// class TenSecondPanicScreen extends StatefulWidget {
//   @override
//   _TenSecondPanicScreenState createState() => _TenSecondPanicScreenState();
// }
//
// class _TenSecondPanicScreenState extends State<TenSecondPanicScreen> {
//   final Telephony telephony = Telephony.instance;
//   int countdown = 10; // Start countdown from 10 seconds
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//     _startCountdown();
//   }
//
//   // Request SMS permissions
//   void _requestPermissions() async {
//     bool? permissionsGranted = await telephony.requestSmsPermissions;
//     if (!permissionsGranted!) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("SMS permissions not granted")),
//       );
//     }
//   }
//
//   // Start the countdown timer
//   void _startCountdown() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (countdown > 1) {
//           countdown--;
//         } else {
//           timer.cancel();
//           _sendSMS(); // Send SMS after countdown reaches 0
//         }
//       });
//     });
//   }
//
//   // Function to send an SMS
//   void _sendSMS() async {
//     const String to = "8956799668"; // Replace with the target number
//     const String message = "Panic Alert! The user needs help."; // Replace with your message
//
//     try {
//       await telephony.sendSms(
//         to: to,
//         message: message,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("SMS sent successfully to $to!")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to send SMS: $e")),
//       );
//     }
//   }
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
//             RippleAnimation(
//               color: const Color(0xFFF8BDBB),
//               size: const Size(200, 200),
//               repeat: true,
//               minRadius: 50,
//               ripplesCount: 6,
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundColor: const Color(0xFFEC4A46),
//                 child: Text(
//                   '$countdown',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 60,
//                     fontWeight: FontWeight.w600,
//                   ),
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
//               child: RichText(
//                 textAlign: TextAlign.center,
//                 text: const TextSpan(
//                   text: 'Within ',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: 'Poppins',
//                     color: Colors.black,
//                   ),
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: '10 seconds,',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' your ',
//                     ),
//                     TextSpan(
//                       text: 'close contacts',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' will be alerted of your whereabouts.',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 60),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 'Press the button below to stop SOS alert.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 50),
//               child: ElevatedButton(
//                 onPressed: () {
//                   _timer?.cancel(); // Stop the countdown timer
//                   Navigator.pop(context); // Go back to the previous screen
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




// class TenSecondPanicScreen extends StatefulWidget {
//   @override
//   _TenSecondPanicScreenState createState() => _TenSecondPanicScreenState();
// }
//
// class _TenSecondPanicScreenState extends State<TenSecondPanicScreen> {
//   // final Telephony telephony = Telephony.instance;
//   int countdown = 10; // Countdown starts from 10 seconds
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     // _requestPermissions();
//     _startCountdown();
//   }
//
//   // Start the countdown timer
//   void _startCountdown() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (countdown > 1) {
//           countdown--;
//         } else {
//           timer.cancel();
//         }
//       });
//     });
//   }
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
//             RippleAnimation(
//               repeat: true,
//               duration: const Duration(milliseconds: 900),
//               ripplesCount: 6,
//               color: const Color(0xFFF8BDBB),
//               minRadius: 100,
//               size: const Size(200, 200),
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundColor: const Color(0xFFEC4A46),
//                 child: Text(
//                   '$countdown',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 60,
//                     fontWeight: FontWeight.bold,
//                   ),
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
//               child: RichText(
//                 textAlign: TextAlign.center,
//                 text: const TextSpan(
//                   text: 'Within ',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: 'Poppins',
//                     color: Colors.black,
//                   ),
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: '10 seconds,',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' your ',
//                     ),
//                     TextSpan(
//                       text: 'close contacts',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' will be alerted of your whereabouts.',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 60),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 'Press the button below to stop SOS alert.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 50),
//               child: ElevatedButton(
//                 onPressed: () {
//                   _timer?.cancel(); // Stop countdown timer
//                   Navigator.pop(context); // Navigate back
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



class TenSecondPanicScreen extends StatefulWidget {
  @override
  _TenSecondPanicScreenState createState() => _TenSecondPanicScreenState();
}

class _TenSecondPanicScreenState extends State<TenSecondPanicScreen> {
  int countdown = 10;
  Timer? _timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userEmail;
  final String emergencyMessage = "Help! I need assistance."; // Define the message

  @override
  void initState() {
    super.initState();
    userEmail = _auth.currentUser?.email ?? "unknown_user";
    _startCountdown();
  }

  // Start the countdown timer
  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 1) {
          countdown--;
        } else {
          timer.cancel();
          sendMessagesToContacts(); // Send the emergency message when countdown reaches 0
        }
      });
    });
  }

  // Function to send emergency messages
  Future<void> sendMessagesToContacts() async {
    try {
      print("Fetching emergency contacts for $userEmail...");

      // Step 1: Get the logged-in user's emergency contacts
      QuerySnapshot contactsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('emergency_contacts')
          .get();

      if (contactsSnapshot.docs.isEmpty) {
        print("No emergency contacts found!");
        return;
      }

      for (var contact in contactsSnapshot.docs) {
        String phone = contact['phone']; // Get B's phone number
        print("Checking for phone: $phone in userwithphone collection...");

        // Step 2: Fetch B's email using phone number
        DocumentSnapshot phoneDoc = await FirebaseFirestore.instance
            .collection('userwithphone')
            .doc(phone)
            .get();

        if (!phoneDoc.exists || phoneDoc.data() == null) {
          print("No email found for phone: $phone");
          continue;
        }

        Map<String, dynamic> phoneData = phoneDoc.data() as Map<String, dynamic>;

        if (!phoneData.containsKey('email')) {
          print("Phone number found, but no email associated.");
          continue;
        }

        String recipientEmail = phoneData['email']; // B's Email
        print("Found recipient email: $recipientEmail");

        // Step 3: Check if B exists in 'users/{B's Email}'
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(recipientEmail)
            .get();

        if (!userDoc.exists) {
          print("Recipient email $recipientEmail does not exist in users collection.");
          continue;
        }

        // Step 4: Store message under B's 'messages' collection
        print("Storing message under users/$recipientEmail/messages...");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(recipientEmail)
            .collection('messages')
            .add({
          'sender': userEmail, // A's Email
          'message': "Help! I'm in danger.",
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("Message successfully stored for $recipientEmail.");
      }

      print("Emergency messages processing completed.");
    } catch (e) {
      print("Error: $e");
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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFFD20451),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
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




