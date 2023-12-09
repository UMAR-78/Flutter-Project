import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/order.dart' as o; // Make sure the import statement is correct

class OrderHistoryScreen extends StatelessWidget {
  final String userId;

  OrderHistoryScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Order History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.yellow,
          bottom: TabBar(
            tabs: [
              Tab(             child: Text('Accepted', style: TextStyle(color: Colors.black)),
            ),
              Tab(
             child: Text('Rejected', style: TextStyle(color: Colors.black)),
            ),
            ],
            indicatorColor: Colors.black,
          ),
          
        ),
        body: TabBarView(
          children: [
            _buildOrdersList(context, 'Accepted'),
            _buildOrdersList(context, 'Rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, String status) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userid', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.black),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No $status orders found.',
              style: TextStyle(color: Colors.black),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            var order = o.Order(
              documentid: snapshot.data!.docs[index].id,
              productid: orderData['productid'],
              userid: orderData['userid'],
              quantity: orderData['quantity'],
              price: orderData['price'].toDouble(),
              status: orderData['status'],
            );

            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('products')
                  .doc(order.productid)
                  .get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                if (productSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (productSnapshot.hasError) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        'Error: ${productSnapshot.error}',
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ID: ${order.documentid}'),
                          Text('Quantity: ${order.quantity}'),
                          Text('Total Price: \$${order.price }'),
                          Text('Status: ${order.status}'),
                        ],
                      ),
                    ),
                  );
                }

                if (!productSnapshot.hasData || productSnapshot.data == null) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Product Not Found or Deleted'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ID: ${order.documentid}'),
                          Text('Quantity: ${order.quantity}'),
                          Text('Total Price: \$${order.price }'),
                          Text('Status: ${order.status}'),
                        ],
                      ),
                    ),
                  );
                }

                var productData = productSnapshot.data!.data() as Map<String, dynamic>?;

                if (productData == null) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Product Data is Null'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ID: ${order.documentid}'),
                          Text('Quantity: ${order.quantity}'),
                          Text('Total Price: \$${order.price }'),
                          Text('Status: ${order.status}'),
                        ],
                      ),
                    ),
                  );
                }

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Product: ${productData['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${productData['description']}'),
                        Text('Price: \$${productData['price']}'),
                        Text('Quantity: ${order.quantity}'),
                        Text('Total Price: \$${order.price }'),
                        Text('Status: ${order.status}'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
