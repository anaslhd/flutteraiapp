import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // For input formatting

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Declare the controllers
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _birthdayController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _passwordController;
  FocusNode _postalCodeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    // Initialize the controllers
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _birthdayController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    _passwordController = TextEditingController();
    
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          var data = snapshot.data() as Map<String, dynamic>;

          // Populate controllers with the fetched data
          _emailController.text = user.email ?? ''; // Example for email
          _addressController.text = data['address'] ?? '';
          _birthdayController.text = data['birthday'] ?? '';
          _cityController.text = data['city'] ?? '';
          _postalCodeController.text = data['postalCode'] ?? '';
          _passwordController.text = data['password'] ?? '';
        } else {
          print('No user document found for the given UID');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _emailController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
    void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully logged out')));
        Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to log out')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email is readonly
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              readOnly: true,
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Birthday'),
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
          TextFormField(
  controller: _postalCodeController,
  decoration: InputDecoration(labelText: 'Postal Code'),
  focusNode: _postalCodeFocusNode,
  keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false), // More specific keyboard options
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly, // Only allow numeric input
  ],
),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                // Handle save/update logic
                _saveUserData();
              },
              child: Text('Valider'),
            ),
            SizedBox(height: 20), // Add some space between buttons
            ElevatedButton(
              onPressed: () {
                // Handle logout logic
                _logout();
              },
              child: Text('Se Déconnecter'),
            ),
            SizedBox(height: 20), // Add some space between buttons
            ElevatedButton(
              onPressed: () {
                // Navigate to Add Article screen (you can replace this with your own navigation logic)
               
              },
              child: Text('Ajouter Article'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Check if the password is updated
        String newPassword = _passwordController.text;
        if (newPassword.isNotEmpty) {
          // Update password in Firebase Authentication
          await user.updatePassword(newPassword);
        }

        // Save updated user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'address': _addressController.text,
          'birthday': _birthdayController.text,
          'city': _cityController.text,
          'postalCode': _postalCodeController.text,
          'password': newPassword, // This stores the new password in Firestore
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));

      } catch (e) {
        print('Error updating user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
      }
    }
  }
}
