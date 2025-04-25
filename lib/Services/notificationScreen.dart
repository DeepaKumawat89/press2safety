import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';


class NotificationScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final String? userEmail = _auth.currentUser?.email;

    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Notifications")),
        body: Center(child: Text("User not logged in")),
      );
    }

    final smsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('sms');

    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Alerts"),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: smsRef.where('read', isEqualTo: false).snapshots(),
            builder: (context, snapshot) {
              int unreadCount = snapshot.data?.docs.length ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$unreadCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: smsRef.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text("No notifications yet"));

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final isRead = data['read'] ?? false;

              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
              final formattedTime = timestamp != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp)
                  : "Unknown time";

              return GestureDetector(
                onTap: () async {
                  if (!isRead) {
                    await doc.reference.update({'read': true});
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isRead ? Colors.grey[100] : Colors.red[100],
                    border: Border.all(
                        color: isRead ? Colors.grey : Colors.redAccent, width: 1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black12,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🚨 Emergency from ${data['senderName'] ?? 'Unknown'}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text("📞 ${data['senderPhone'] ?? 'N/A'}"),
                      GestureDetector(
                        onTap: () {
                          // Open new screen to view and copy the address
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressDetailScreen(address: data['postalAddress'] ?? 'N/A'),
                            ),
                          );
                        },
                        child: Text(
                          "📍 ${data['postalAddress'] ?? 'N/A'}",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text("💬 ${data['message'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 6),
                      Text("🕒 $formattedTime", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



class AddressDetailScreen extends StatelessWidget {
  final String address;

  AddressDetailScreen({required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Address Details")),











      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Location Address",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              address,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: address)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Address copied to clipboard")));
                });
              },
              child: Text("Copy Address"),
            ),
          ],
        ),
      ),
    );
  }
}
