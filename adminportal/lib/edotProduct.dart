import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'viewProduct.dart';
import 'models/product.dart';
class ProductEditScreen extends StatefulWidget {
  final Product product;

  ProductEditScreen({required this.product});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
 TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    descriptionController = TextEditingController(text: widget.product.description);
    priceController = TextEditingController(text: widget.product.price.toString());
    //imageController = TextEditingController(text: widget.product.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(
          'Edit Product',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
           
            SizedBox(height: 20),
            ElevatedButton(
  onPressed: () async{
     // Update the product in Firestore
      try {
  await FirebaseFirestore.instance.collection('products').doc(widget.product.documentid).update({
    'name': nameController.text,
    'description': descriptionController.text,
    'price': double.parse(priceController.text),
    // 'image': imageController.text,
  });
 Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductListScreen()),
    );
    // Return to the product list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Updated Successfully", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
} catch (e) {
  // Handle the error (e.g., show an error message to the user)
  print('Error updating product: $e');
   ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error While Updating", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.redAccent,
        ),
      );
} // Return to the product list
  },
  style: ElevatedButton.styleFrom(
    primary: Colors.yellow, // Change the background color to yellow
    onPrimary: Colors.black, // Change the text color to black
  ),
  child: Text('Save Changes'),
)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }
}
