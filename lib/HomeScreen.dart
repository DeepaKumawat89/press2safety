import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'MapScreen.dart';
import 'Navigations/appbar.dart';
import 'Navigations/bottomnavbar.dart';
import 'RecordingScreen/RecordScreen.dart';
import 'Test/login.dart';

class HomeScreen extends StatefulWidget {
  final Position userLocation;  // Add a userLocation field


  const HomeScreen({super.key, required this.userLocation});  // Accept userLocation in constructor

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;

  Future<Map<String, dynamic>> _fetchUserDetails() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.email).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    }
    return {};
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen()),
    ).then((_) => setState(() {})); // Refresh HomeScreen on return
  }

  void _logout(BuildContext context) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await _auth.signOut();
      // Replace the current screen with the LoginScreen widget directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login2()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  CustomAppBar(
        onEditProfile: () => setState(() {}),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children:  [
            MapScreen(userLocation: widget.userLocation), // Pass userLocation to MapScreen
            RecordScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
// backgroundColor: Colors.white,
// appBar: AppBar(
//    const CustomAppBar(),
//   title: FutureBuilder<Map<String, dynamic>>(
//     future: _fetchUserDetails(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Text('Hi');
//       } else if (snapshot.hasError) {
//         return const Text('Error');
//       } else {
//         final userDetails = snapshot.data ?? {};
//         return Text('Hi, ${userDetails['username'] ?? 'User'}');
//       }
//     },
//   ),
// ),
// drawer: FutureBuilder<Map<String, dynamic>>(
//   future: _fetchUserDetails(),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return const Drawer(
//         child: Center(child: CircularProgressIndicator()),
//       );
//     } else if (snapshot.hasError) {
//       return const Drawer(
//         child: Center(child: Text('Error loading profile')),
//       );
//     } else {
//       final userDetails = snapshot.data ?? {};
//       return Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(color: Colors.blue),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundImage: userDetails['profileImage'] != null
//                         ? MemoryImage(base64Decode(userDetails['profileImage']))
//                         : null,
//                     child: userDetails['profileImage'] == null
//                         ? const Icon(Icons.person, size: 40)
//                         : null,
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     userDetails['username'] ?? 'Username not available',
//                     style: const TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                   Text(
//                     userDetails['email'] ?? 'Email not available',
//                     style: const TextStyle(fontSize: 14, color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.person, color: Colors.blue),
//               title: const Text('Edit Profile'),
//               onTap: () => _navigateToEditProfile(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text('Logout'),
//               onTap: () => _logout(context),
//             ),
//           ],
//         ),
//       );
//     }
//   },
// ),




