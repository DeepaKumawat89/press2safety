import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:press2safety/Auth/Login1.dart';
import '../Utils/Image_strings.dart';
import '../Utils/colors.dart';
import '../Test/login.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;
  final VoidCallback onEditProfile; // Add this parameter

   CustomAppBar({Key? key, required this.onEditProfile}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(85);

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

  void _navigateToEditProfile(BuildContext context, VoidCallback refreshCallback) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen()),
    ).then((_) => refreshCallback()); // Trigger the refresh callback on return
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
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 90,
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SvgPicture.asset(
                ImageStrings.lightAppLogo,
                width: 80,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 0.0, top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  //badgeContent:
                  //  const Text('3', style: TextStyle(color: Colors
                  //  .white)),
                  //badgeStyle: const badges.BadgeStyle(
                  //  badgeColor: AppColors.badgePrimary,
                  //  padding: EdgeInsets.all(6),
                  //  shape: badges.BadgeShape.circle,
                  //  ),
                  child: IconButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print("Notification btn");
                      }
                    },
                    icon: const Icon(Icons.notifications),
                    color: AppColors.iconPrimary,
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                            initialChildSize: 0.6,
                            minChildSize: 0.4,
                            maxChildSize: 0.9,
                            builder: (BuildContext context, ScrollController scrollController) {
                              return FutureBuilder<Map<String, dynamic>>(
                                future: _fetchUserDetails(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Center(child: Text('Error loading profile')),
                                    );
                                  } else {
                                    final userDetails = snapshot.data ?? {};
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: ListView(
                                        controller: scrollController,
                                        padding: EdgeInsets.zero,
                                        children: [
                                          DrawerHeader(
                                            decoration: const BoxDecoration(color: Colors.blue),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: userDetails['profileImage'] != null
                                                      ? MemoryImage(base64Decode(userDetails['profileImage']))
                                                      : null,
                                                  child: userDetails['profileImage'] == null
                                                      ? const Icon(Icons.person, size: 40)
                                                      : null,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  userDetails['username'] ?? 'Username not available',
                                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                                ),
                                                Text(
                                                  userDetails['email'] ?? 'Email not available',
                                                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.person, color: Colors.blue),
                                            title: const Text('Edit Profile'),
                                            onTap: () => _navigateToEditProfile(context,onEditProfile),
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.shield, color: Colors.green),
                                            title: const Text('View Safety Tips'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => SafetyTipsScreen()),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.logout, color: Colors.red),
                                            title: const Text('Logout'),
                                            onTap: () => _logout(context),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.menu),
                    color: AppColors.iconPrimary,
                  ),
                ),
                 SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(color: AppColors.dividerPrimary),
      ),
    );
  }
}


class BottomToTopAnimatedRoute extends PageRouteBuilder<void> {
  final Widget page;

  BottomToTopAnimatedRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1);
      const end = Offset(0.0, 0.0);
      final tween = Tween<Offset>(begin: begin, end: end).animate(animation);
      return SlideTransition(
        position: tween,
        child: child,
      );
    },
  );
}

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _base64Image;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.email).update({
        'username': _usernameController.text,
        'age': _ageController.text,
        'address': _addressController.text,
        'altPhoneNumber': _phoneController.text,
        'profileImage': _base64Image,
      });
    }
  }

  Future<void> _fetchUserDetails() async {
    final user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.email).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _usernameController.text = data['username'] ?? '';
          _ageController.text = data['age'] ?? '';
          _addressController.text = data['address'] ?? '';
          _phoneController.text = data['altPhoneNumber'] ?? '';
          _base64Image = data['profileImage'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _base64Image != null
                    ? MemoryImage(base64Decode(_base64Image!))
                    : null,
                child: _base64Image == null
                    ? Icon(Icons.add_a_photo, size: 50)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Alternative Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveProfile();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class SafetyTipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Tips'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            SafetyTipCard(
                title: "Stay Aware of Your Surroundings",
                description: "Always be aware of your surroundings, especially in unfamiliar places."
            ),
            SafetyTipCard(
                title: "Share Your Location",
                description: "Keep trusted contacts informed about your location when traveling alone."
            ),
            SafetyTipCard(
                title: "Use Emergency Features",
                description: "Know how to quickly access emergency contacts and features on your phone."
            ),
            SafetyTipCard(
                title: "Trust Your Instincts",
                description: "If something feels wrong, trust your instincts and remove yourself from the situation."
            ),
            SafetyTipCard(
                title: "Keep a Personal Safety Tool",
                description: "Carry items like a whistle, pepper spray, or a personal alarm for added security."
            ),
            SafetyTipCard(
                title: "Avoid Isolated Areas",
                description: "Stay in well-lit and crowded areas, especially at night."
            ),
            SafetyTipCard(
                title: "Use Safe Transportation",
                description: "Prefer trusted ride-sharing services or public transport instead of accepting rides from strangers."
            ),
            SafetyTipCard(
                title: "Know Basic Self-Defense",
                description: "Learn simple self-defense techniques that can help in emergencies."
            ),
            SafetyTipCard(
                title: "Have an Escape Plan",
                description: "Plan an exit strategy when entering a new location, ensuring you have a way to leave if needed."
            ),
            SafetyTipCard(
                title: "Limit Sharing on Social Media",
                description: "Avoid sharing real-time locations and travel plans publicly online."
            ),
          ],
        ),
      ),
    );
  }
}

class SafetyTipCard extends StatelessWidget {
  final String title;
  final String description;

  const SafetyTipCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}



