import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PanierScreen extends StatefulWidget {
  @override
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> items = [];
  int totalItems = 0;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchPanierItems();
  }

  Future<void> fetchPanierItems() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("User is not logged in");
      }

      final String uid = user.uid;

      final QuerySnapshot snapshot = await _firestore
          .collection('paniers')
          .doc(uid)
          .collection('items')
          .get();

      final List<Map<String, dynamic>> fetchedItems = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Include the document ID for deletion
        return data;
      }).toList();

      int priceSum = fetchedItems.fold(0, (sum, item) => sum + (item['price'] as int));
      int itemCount = fetchedItems.length;

      setState(() {
        items = fetchedItems;
        totalItems = itemCount;
        totalPrice = priceSum;
      });
    } catch (error) {
      print('Error fetching panier items: $error');
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("User is not logged in");
      }

      final String uid = user.uid;

      await _firestore
          .collection('paniers')
          .doc(uid)
          .collection('items')
          .doc(itemId)
          .delete();

      // Refresh the panier items after deletion
      fetchPanierItems();
    } catch (error) {
      print('Error deleting item: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Votre Panier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text('Votre panier est vide.'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Image.network(
                              item['imageUrl'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                            ),
                            title: Text(item['title']),
                            subtitle: Text(
                              'Prix: ${item['price']} | Taille: ${item['size']}',
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteItem(item['id']),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: $totalPrice DA',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Articles: $totalItems',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
