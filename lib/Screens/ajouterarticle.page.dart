import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AjouterArticlePage extends StatefulWidget {
  @override
  _AjouterArticlePageState createState() => _AjouterArticlePageState();
}

class _AjouterArticlePageState extends State<AjouterArticlePage> {
  XFile? _selectedImage;
  String _category = "Unknown";
  bool _isLoading = false;

  // Pick image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
        _isLoading = true;
      });

      // Send the image to Flask for prediction
      _predictCategory(image);
    }
  }

  // Send image to Flask API and get prediction
  Future<void> _predictCategory(XFile image) async {
    final Uri apiUrl = Uri.parse('http://10.0.2.2:5000/predict');  // Replace with your Flask API URL

    var request = http.MultipartRequest('POST', apiUrl);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);

      // Ensure you retrieve the category name, not the index
      setState(() {
        _category = data['category'] ?? 'Unknown';  // Handle case where 'category' might not be in response
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
        title: Text('Ajouter un Article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Button to pick an image
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image'),
            ),
            SizedBox(height: 20),
            // Display the picked image
            _selectedImage != null
                ? Image.file(File(_selectedImage!.path))
                : Text('No image selected'),
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
