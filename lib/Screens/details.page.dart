import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final int price;
  final String size;
  final String imageUrl;
  final String marque;
  final String categorie;

  DetailsScreen({
    required this.title,
    required this.price,
    required this.size,
    required this.imageUrl,
    required this.marque,
    required this.categorie
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () => Navigator.pop(context), // Navigate back to the previous screen
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              imageUrl,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 100),
            ),
            SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text('Prix: $price', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 8.0),
            Text('Taille: $size', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 8.0),
            Text('Marque: $marque', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 8.0),
            Text('Categorie: $categorie', style: TextStyle(fontSize: 20.0)),
            Spacer(), // This will push the button to the bottom
            ElevatedButton(
              onPressed: () {
                // Action for adding to cart can be placed here
                print('Article ajouté au panier');
              },
              child: Text('Ajouter au panier'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                textStyle: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
