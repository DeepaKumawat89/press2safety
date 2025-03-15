import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Navigations/appbar.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = _auth.currentUser?.email ?? "unknown_user";
  }

  Future<void> addContact(String name, String phone) async {
    final contactRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('emergency_contacts')
        .doc();

    await contactRef.set({'name': name, 'phone': phone});
  }

  Future<void> deleteContact(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('emergency_contacts')
        .doc(docId)
        .delete();
  }

  // Check if there are less than 5 contacts
  Future<int> getContactsCount() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('emergency_contacts')
        .get();

    return snapshot.docs.length;
  }

  void showAddContactDialog() async {
    // Get the current number of contacts
    int contactCount = await getContactsCount();

    if (contactCount >= 5) {
      // If there are 5 or more contacts, show a limit message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Contact Limit Reached"),
            content: const Text("You can only add up to 5 contacts."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // If there are less than 5 contacts, show the add contact dialog
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  addContact(nameController.text, phoneController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget contactTile(String docId, String name, String phoneNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Text(name[0].toUpperCase()),
            radius: 30.0,
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                phoneNumber,
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteContact(docId),
          ),
        ],
      ),
    );
  }

  Widget addContactTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: showAddContactDialog,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
              radius: 30.0,
            ),
            const SizedBox(width: 10.0),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Contact',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Max. 5 contacts',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onEditProfile: () {}), // Use CustomAppBar here
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userEmail)
                        .collection('emergency_contacts')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var contacts = snapshot.data!.docs;

                      return Column(
                        children: contacts.map((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          return contactTile(doc.id, data['name'], data['phone']);
                        }).toList(),
                      );
                    },
                  ),
                  addContactTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
