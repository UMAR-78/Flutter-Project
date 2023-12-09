import 'package:flutter/material.dart';
import 'models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  final String userId;
  final Product product;

  CartScreen({required this.userId, required this.product});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _checkCartItem();
  }

  void _checkCartItem() async {
    // Check if the item already exists in the cart
    QuerySnapshot<Map<String, dynamic>> existingItems = await FirebaseFirestore.instance
        .collection('cart')
        .where('userid', isEqualTo: widget.userId)
        .where('productid', isEqualTo: widget.product.documentid)
        .get();

    if (existingItems.docs.isNotEmpty) {
      // Item already exists in the cart
      DocumentSnapshot<Map<String, dynamic>> existingItem = existingItems.docs.first;
      int existingQuantity = existingItem['quantity'] as int;

      setState(() {
        quantity = existingQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              ' ${widget.product.description}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              ' \$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CircleAvatar for decreasing quantity
                CircleAvatar(
                  radius: 15, // Adjust the size as needed
                  backgroundColor: Colors.yellow,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.remove, size: 15),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      color: Colors.black,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    ' $quantity',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                // CircleAvatar for increasing quantity
                CircleAvatar(
                  radius: 15, // Adjust the size as needed
                  backgroundColor: Colors.yellow,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.add, size: 15),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add the item to the cart
                _addToCart();
               
              },
              child: Text('Done'),
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
                onPrimary: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() async {
    double totalPrice = (widget.product.price as double) * quantity;

    // Check if the item already exists in the cart
    QuerySnapshot<Map<String, dynamic>> existingItems = await FirebaseFirestore.instance
        .collection('cart')
        .where('userid', isEqualTo: widget.userId)
        .where('productid', isEqualTo: widget.product.documentid)
        .get();

    if (existingItems.docs.isNotEmpty) {
      // Item already exists in the cart, update the quantity
      DocumentSnapshot<Map<String, dynamic>> existingItem = existingItems.docs.first;
      int updatedQuantity = quantity;


      await FirebaseFirestore.instance.collection('cart').doc(existingItem.id).update({
        'quantity': updatedQuantity,
        'price':totalPrice,
      });

      // Update the UI to reflect the existing quantity
      setState(() {
        quantity = updatedQuantity;
        
      });
    } else {
      // Item does not exist in the cart, add a new entry
      await FirebaseFirestore.instance.collection('cart').add({
        'userid': widget.userId,
        'productid': widget.product.documentid,
        'quantity': quantity,
        'price': totalPrice,
      });
    }
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Item added to cart", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );

    // Navigate back to the previous screen
    Navigator.pop(context);
  }
}
