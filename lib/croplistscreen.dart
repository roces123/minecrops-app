import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cropdetailscreen.dart';

class CropListScreen extends StatelessWidget {
  final String categoryName;

  CropListScreen({super.key, required this.categoryName});

  final Map<String, String> categoryMapping = {
    "Grain Crops": "grains",
    "Fruit Crops": "fruits",
    "Vegetable Crops": "vegetables",
    "Roots Crops": "roots",
    "Legumes Crops": "legumes",
    "Industrial/Commercial Crops": "industrial/commercial",
    "Spices/Herbs": "spices/herbs"

  };

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> getCropStream() {
      if (categoryName == "All Crops") {
        return FirebaseFirestore.instance.collection('crops').snapshots();
      }

      final firestoreCategory = categoryMapping[categoryName];
      if (firestoreCategory == null) {
        return FirebaseFirestore.instance.collection('crops').snapshots();
      }

      return FirebaseFirestore.instance
          .collection('crops')
          .where('Category', isEqualTo: firestoreCategory)
          .snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: const Color(0xFF6B8E23),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getCropStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No crops found for $categoryName."));
          }

          final crops = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: crops.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final doc = crops[index];
              final data = doc.data() as Map<String, dynamic>;
              data['_docId'] = doc.id;

              final name = data['Name'] ?? "No Name";
              final imageUrl = data['Image Url'] ?? "";

              // Pass context here
              return _buildCropCard(context, name, imageUrl, doc.id, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildCropCard(BuildContext context, String name, String imageUrl, String docId, Map<String, dynamic> cropData) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              child: Hero(
                tag: docId,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CropDetailScreen(cropData: cropData),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
