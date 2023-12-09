import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteProductsScreen extends StatelessWidget {
  final String userId;

  FavoriteProductsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Favorite Products',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favourite')
            .where('userid', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorite products found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var favoriteData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var productId = favoriteData['productid'];

              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                  if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (productSnapshot.hasError) {
                    return Center(child: Text('Error: ${productSnapshot.error}'));
                  }

                  if (productSnapshot.hasData && productSnapshot.data != null) {
                    var productData = productSnapshot.data!.data() as Map<String, dynamic>?;

                    if (productData != null) {
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Product: ${productData['name']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (productData['description'] != null)
                                Text('Description: ${productData['description']}'),
                              if (productData['price'] != null)
                                Text('Price: \$${productData['price']}'),
                            ],
                          ),
                        ),
                      );
                    }
                  }

                  // Product not found or null, handle accordingly
                  return Center(child: Text(''));
                },
              );
            },
          );
        },
      ),
    );
  }
}
