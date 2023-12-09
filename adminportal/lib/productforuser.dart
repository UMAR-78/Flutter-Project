import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product.dart';
import 'models/fav.dart';
import 'AddCart.dart';

class ProductListUser extends StatefulWidget {
  final String userId;

  ProductListUser({required this.userId});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductListUser> {
  List<Product> products = [];
  List<Fav> favorites = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Fetch products
    QuerySnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').get();

    // Convert QuerySnapshot to a list of products
    List<Product> productList = productSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      double price = (data['price'] as num).toDouble();
      return Product(
        documentid: doc.id,
        name: data['name'],
        description: data['description'],
        price: price,
      );
    }).toList();

    // Fetch favorites
    QuerySnapshot favSnapshot = await FirebaseFirestore.instance.collection('favourite').where('userid', isEqualTo: widget.userId).get();

    List<Fav> favList = favSnapshot.docs.map((doc1) {
      Map<String, dynamic> data1 = doc1.data() as Map<String, dynamic>;

      return Fav(
        documentid: doc1.id,
        userid: data1['userid'],
        productid: data1['productid'],
      );
    }).toList();

    // Set the state with fetched data
    setState(() {
      products = productList;
      favorites = favList;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: products.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              bool isFavorite =
                  favorites.any((fav) => fav.userid == widget.userId && fav.productid == product.documentid);

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image.asset(products[index].image, width: 80, height: 80),
                      Text(
                        products[index].name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        products[index].description,
                      ),
                      Text(
                        '\$${products[index].price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                   trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    // Handle favorite button click
                    _toggleFavorite(product);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Open cart screen
                   // _openCartScreen(product);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(userId: widget.userId, product: product),
                        ),
                      );
                  },
                ),
              ]
                ),
            
               
            
                ),
              );
            },
          ),
  );
}


 void _toggleFavorite(Product product) async {
  // Check if the product is already a favorite
  bool isFavorite = favorites.any((fav) => fav.userid == widget.userId && fav.productid == product.documentid);

  CollectionReference favoritesCollection = FirebaseFirestore.instance.collection('favourite');

  if (isFavorite) {
    // Remove from favorites
    QuerySnapshot querySnapshot = await favoritesCollection.where('userid', isEqualTo: widget.userId).where('productid', isEqualTo: product.documentid).get();
    querySnapshot.docs.forEach((doc) {
      favoritesCollection.doc(doc.id).delete();
    });
  } else {
    // Add to favorites
    await favoritesCollection.add({
      'userid': widget.userId,
      'productid': product.documentid,
    });
  }

  // Refresh the data
  _fetchData();
}

}

