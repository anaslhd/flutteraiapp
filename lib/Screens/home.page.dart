import 'package:flutter/material.dart';
import 'package:flutteraiapp/Screens/acheter.page.dart';
import 'package:flutteraiapp/Screens/profile.page.dart';
import 'details.page.dart'; // Import the details screen

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Function to navigate to the details screen
  void _navigateToDetails(String title, int price, String size, String imageUrl,String marque,String Categorie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          title: title,
          price: price,
          size: size,
          imageUrl: imageUrl,
          marque: marque,
          categorie: Categorie,
        ),
      ),
    );
  }

  // Pages to display based on the bottom navbar selection
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    // Initialize the _pages list with the `AcheterScreen` that supports navigation
    _pages.addAll([
      AcheterScreen(onItemTapped: _navigateToDetails), // Pass the function to AcheterScreen
      Center(child: Text("Search Page", style: TextStyle(fontSize: 24))),
      ProfilePage(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          "Anas Clothing App",
          style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.money, color: _currentIndex == 0 ? Colors.green : Colors.black),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trolley),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
