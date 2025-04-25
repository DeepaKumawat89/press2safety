import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewRecordingsHistory extends StatelessWidget {
  final String userID;
  const ViewRecordingsHistory({super.key, required this.userID});

  Future<List<Uint8List>> fetchImages() async {
    final firestore = FirebaseFirestore.instance;
    List<Uint8List> imageList = [];

    final dateSnapshots = await firestore
        .collection('users')
        .doc(userID)
        .collection('images')
        .get();

    for (var dateDoc in dateSnapshots.docs) {
      final timestampDocs = await firestore
          .collection('users')
          .doc(userID)
          .collection('images')
          .doc(dateDoc.id)
          .collection('records')
          .get();

      for (var record in timestampDocs.docs) {
        final data = record.data();
        if (data.containsKey('image')) {
          try {
            Uint8List imageBytes = base64Decode(data['image']);
            imageList.add(imageBytes);
          } catch (e) {
            print('Failed to decode image: $e');
          }
        }
      }
    }

    return imageList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recording History")),
      body: FutureBuilder<List<Uint8List>>(
        future: fetchImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final images = snapshot.data ?? [];

          if (images.isEmpty) {
            return const Center(child: Text("No images found."));
          }

          return ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(10),
                child: Image.memory(images[index], fit: BoxFit.cover),
              );
            },
          );
        },
      ),
    );
  }
}
