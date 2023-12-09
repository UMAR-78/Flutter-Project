import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/cart.dart';

class CartListUser extends StatefulWidget {
  final String userId;

  CartListUser({required this.userId});

  @override
  _CartListUserState createState() => _CartListUserState();
}

class _CartListUserState extends State<CartListUser> {
  List<Cart> cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  // Add this method to handle removing the item from the cart
Future<void> _removeFromCart(Cart cartItem) async {
  // Remove the item from the cart
  await FirebaseFirestore.instance.collection('cart').doc(cartItem.documentid).delete();
 ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Remove from Cart", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
  // Fetch updated cart data
  await _fetchData();
}

  Future<void> _fetchData() async {
    // Fetch cart items
    QuerySnapshot cartSnapshot =
        await FirebaseFirestore.instance.collection('cart').where('userid', isEqualTo: widget.userId).get();

    // Convert QuerySnapshot to a list of cart items
    List<Cart> cartItemList = cartSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Cart(
        documentid: doc.id,
        userid: data['userid'],
        productid: data['productid'],
        quantity: data['quantity'],
        price: data['price'],
      );
    }).toList();

    // Set the state with fetched data
    setState(() {
      cartItems = cartItemList;
    });
  }

  Future<void> _confirmOrder(Cart cartItem) async {
    // Add order to the "orders" collection
    await FirebaseFirestore.instance.collection('orders').add({
      'productid': cartItem.productid,
      'userid':cartItem.userid,
      'price':cartItem.price,
      'quantity':cartItem.quantity,
      'timestamp': FieldValue.serverTimestamp(),
      'status':'Pending'
    });

    // Remove the confirmed item from the cart
    await FirebaseFirestore.instance.collection('cart').doc(cartItem.documentid).delete();
 ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Order Placed", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
    // Fetch updated cart data
    await _fetchData();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Cart Details',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.yellow,
    ),
    body: cartItems.isEmpty
        ? Center(
            child: Text('No items in the cart'),
          )
        : ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              Cart cartItem = cartItems[index];

              return ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('products')
                          .doc(cartItem.productid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic>? productData =
                              snapshot.data!.data() as Map<String, dynamic>?;

                          if (productData != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Name: ${productData['name']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Description: ${productData['description']}'),
                                Text('Quantity: ${cartItem.quantity}'),
                                Text(
                                  'Unit Price: \$${productData['price'].toStringAsFixed(2)}',
                                ),
                                Text(
                                  'Total Price: \$${cartItem.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Text('Product details not available');
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _confirmOrder(cartItem);
                      },
                      icon: Icon(Icons.check, color: Colors.green),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      onPressed: () {
                        // Handle Reject button click
                        // You can add your logic here
                        _removeFromCart(cartItem);
                      },
                      icon: Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),
              );
            },
          ),
  );
}
}