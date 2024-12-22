import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcheterScreen extends StatelessWidget {
  final Function(String, int, String, String,String,String) onItemTapped;

  AcheterScreen({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Clothes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final clothes = snapshot.data!.docs;

        return ListView.builder(
          itemCount: clothes.length,
          itemBuilder: (context, index) {
            final clothing = clothes[index];
            final title = clothing['titre'] as String;
            final price = clothing['Prix'] as int;
            final size = clothing['Taille'] as String;
            final imageUrl = clothing['image'] as String;
            final marque=clothing['marque'] as String;
            final categorie=clothing['Categorie'] as String;

            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                ),
                title: Text(title),
                subtitle: Text('Prix: $price\nTaille: $size'),
                onTap: () => onItemTapped(title, price, size, imageUrl,marque,categorie), // Trigger navigation
              ),
            );
          },
        );
      },
    );
  }
}
