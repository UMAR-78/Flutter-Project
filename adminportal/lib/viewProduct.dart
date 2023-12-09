import 'package:adminportal/Widgets/CustomerAppbar.dart';
import 'package:adminportal/addproduct.dart';
import 'package:adminportal/edotProduct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product.dart';




class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> products = [];
  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore when the widget is initialized
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    // Fetch products from Firestore
    // Make sure to replace 'your_firestore_collection' with the actual collection name
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    // Convert QuerySnapshot to a list of products
    List<Product> productList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      double price = (data['price'] as num).toDouble();
      return Product(
        documentid: doc.id,
        name: data['name'],
        description: data['description'],
        price: price,
      );
    }).toList();

    // Update the state to trigger a rebuild with the fetched products
    setState(() {
      products = productList;
    });
  }
  Future<void> _deleteProduct(String documentId) async {
    // Delete the product from Firestore
    await FirebaseFirestore.instance.collection('products').doc(documentId).delete();

    // Update the UI to remove the deleted product
    setState(() {
      products.removeWhere((product) => product.documentid == documentId);
    });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Remove Product", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Row(
                children: [
                //  Image.asset(products[index].image,
                  //    width: 80, height: 80), // Add the image here
                  SizedBox(width: 16.0), // Add spacing between image and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Add the edit product logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductEditScreen(product: products[index]),
                        ),
                      ).then((result) {
                        if (result != null) {
                          // Handle the data returned from the edit screen.
                          print('Data returned from edit screen: $result');
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                     _deleteProduct(products[index].documentid);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(product: products[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>AddProduct(),
            ),
          );
        },
        backgroundColor: Colors.yellow, 
        child: Icon(Icons.add,color: Colors.black,),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          'Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 16.0), // Add spacing at the top
        Container(
          width: 200, // Set the image container width
          height: 200, // Set the image container height
        //  child: Image.asset(product.image),
        ),
        SizedBox(height: 16.0), // Add spacing between the image and text
        Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text('Description: ${product.description}', style: TextStyle(
            fontSize: 20,
          ),),
        Text(
          'Price: \$${product.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        // Add more details as needed
      ],
    ),
  ),
    );
  }
}
