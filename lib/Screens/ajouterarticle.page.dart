import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AjouterArticlePage extends StatefulWidget {
  @override
  _AjouterArticlePageState createState() => _AjouterArticlePageState();
}

class _AjouterArticlePageState extends State<AjouterArticlePage> {
  String _category = "Unknown";
  bool _isLoading = false;
  TextEditingController _imageUrlController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  // Send data to Firestore instead of an API
  Future<void> _addClothes() async {
    if (_imageUrlController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide all required fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse the price as an integer
      int price = int.tryParse(_priceController.text) ?? 0;

      // Save the data to Firestore
      await FirebaseFirestore.instance.collection('Clothes').add({
        'categorie': _category,
        'Prix': price,  // Store price as integer
        'Taille': _sizeController.text,
        'image': _imageUrlController.text,
        'marque': _brandController.text,
        'titre': _titleController.text,
        // Optionally include a timestamp
      });

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clothes added successfully!')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add clothes.')),
      );
    }
  }

  // Send image URL to Flask API and get prediction
  Future<void> _predictCategoryFromUrl(String url) async {
    if (url.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final Uri apiUrl = Uri.parse('http://10.0.2.2:5000/predict'); // Replace with your Flask API URL

    var request = http.MultipartRequest('POST', apiUrl);
    request.fields['image_url'] = url;

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);

      setState(() {
        _category = data['category'] ?? 'Unknown';
        _isLoading = false;
      });
    } else {
      setState(() {
        _category = "Error: Could not get prediction";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter Vêtements'),  // Title of the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),  // Back arrow icon
          onPressed: () {
            Navigator.pop(context);  // Pop the current page from the stack to go back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field for Image URL
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: "Enter Image URL",
                border: OutlineInputBorder(),
              ),
              onChanged: (url) {
                // Trigger the prediction automatically when URL changes
                if (url.isNotEmpty) {
                  _predictCategoryFromUrl(url);
                }
              },
            ),
            SizedBox(height: 10),
            // Display the image from URL
            _imageUrlController.text.isNotEmpty
                ? Image.network(
                    _imageUrlController.text,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 10),
            // Category field (readonly)
            TextField(
              controller: TextEditingController(text: _category),
              decoration: InputDecoration(
                labelText: "Categorie",
                border: OutlineInputBorder(),
              ),
              readOnly: true,  // Make category field read-only
            ),
            SizedBox(height: 10),
            // Price field (integer input only)
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: "Prix",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,  // Ensures only numeric input
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,  // Only digits allowed
              ],
            ),
            SizedBox(height: 10),
            // Size field
            TextField(
              controller: _sizeController,
              decoration: InputDecoration(
                labelText: "Taille",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Brand field
            TextField(
              controller: _brandController,
              decoration: InputDecoration(
                labelText: "Marque",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Title field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Titre",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Button to add the item
            ElevatedButton(
              onPressed: _addClothes,
              child: Text('Add Clothes'),
            ),
            SizedBox(height: 20),
            // Display the prediction result
            _isLoading
                ? CircularProgressIndicator()
                : Text('Predicted Category: $_category', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
