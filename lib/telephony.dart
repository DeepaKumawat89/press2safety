// import 'package:flutter/material.dart';
// import 'package:telephony/telephony.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SMSPage(),
//     );
//   }
// }
//
// class SMSPage extends StatefulWidget {
//   @override
//   _SMSPageState createState() => _SMSPageState();
// }
//
// class _SMSPageState extends State<SMSPage> {
//   final Telephony telephony = Telephony.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//   }
//
//   void _requestPermissions() async {
//     bool? permissionsGranted = await telephony.requestSmsPermissions;
//     if (!permissionsGranted!) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("SMS permissions not granted")),
//       );
//     }
//   }
//
//   void _sendSMS() async {
//     const String to = "tuza number add kr";
//     const String message = "message add kar";
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
//   // @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Send SMS"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _sendSMS,
//           child: Text("Send"),
//           style: ElevatedButton.styleFrom(
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//             textStyle: TextStyle(fontSize: 18),
//           ),
//         ),
//       ),
//     );
//   }
// }