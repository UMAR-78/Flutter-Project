import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/order.dart' as o;

class OrderControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Confirmation',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: 'Pending').snapshots(),
         builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<o.Order> orders = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            return o.Order(
              documentid: doc.id,
              productid: data['productid'],
              userid: data['userid'],
              quantity: data['quantity'],
              price: data['price'],
              status: data['status'],
            );
          }).toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              o.Order order = orders[index];

              return Card(
                margin: EdgeInsets.all(16.0),
                elevation: 4.0,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text('Order #: ${order.documentid}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('user').doc(order.userid).get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.done) {
                            Map<String, dynamic>? userData = userSnapshot.data!.data() as Map<String, dynamic>?;

                            if (userData != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Customer: ${userData['firstname']} ${userData['lastname']}'),
                                  Text('Email: ${userData['email']}'),
                                  // Add more user information as needed
                                ],
                              );
                            } else {
                              return Text('User details not available');
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('products').doc(order.productid).get(),
                        builder: (context, productSnapshot) {
                          if (productSnapshot.connectionState == ConnectionState.done) {
                            Map<String, dynamic>? productData = productSnapshot.data!.data() as Map<String, dynamic>?;

                            if (productData != null) {
                              return Text('Product: ${productData['name']}');
                              
                            } else {
                              return Text('Product details not available');
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      Text('Quantity: ${order.quantity}'),
                      Text('Total Amount: \$${order.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _confirmOrder(order,context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                        ),
                        child: Text('Confirm'),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          _rejectOrder(order,context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                        ),
                        child: Text('Reject'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

 void _confirmOrder(o.Order order,BuildContext context) async {
  try {
    // Update order status to "Accepted"
    await FirebaseFirestore.instance.collection('orders').doc(order.documentid).update({
      'status': 'Accepted',
    });
  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User added to Firestore", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
    // Implement any additional logic needed after confirming the order

  } catch (e) {
    print('Error confirming order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("While Confirming order", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.redAccent ,
        ),
      );
  }
}

void _rejectOrder(o.Order order,BuildContext context) async {
  try {
    // Update order status to "Rejected"
    await FirebaseFirestore.instance.collection('orders').doc(order.documentid).update({
      'status': 'Rejected',
    });
 ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Order Rejected", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
    // Implement any additional logic needed after rejecting the order

  } catch (e) {
    print('Error rejecting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error while rejecting", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.redAccent ,
        ),
      );
  }
}

}
