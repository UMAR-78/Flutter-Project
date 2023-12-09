import 'package:firebase_storage/firebase_storage.dart';
import 'viewProduct.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? imageurl;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<String?> uploadFile(File file) async {
    String filename = file.path.split('/').last;
    Reference storageRef =
        FirebaseStorage.instance.ref().child('gs://saucy-eats.appspot.com/$filename');
    UploadTask uploadTask = storageRef.putFile(file);

    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    if (snapshot.state == TaskState.success) {
      return storageRef.getDownloadURL();
    } else {
      print("File Not Uploaded");
      return null;
    }
  }


  Future<void> _pickImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File file = File(pickedFile.path);
    String? uploadUrl = await uploadFile(file);

    if (uploadUrl != null && uploadUrl.isNotEmpty) {
      setState(() {
        imageurl = uploadUrl;
      });
    }
  }
  }
  

  Future<void> _addProductToFirestore() async {
  if (nameController.text.isNotEmpty &&
      descriptionController.text.isNotEmpty &&
      priceController.text.isNotEmpty) {
    double price = double.tryParse(priceController.text) ?? 0.0;
    
    await FirebaseFirestore.instance.collection('products').add({
      'name': nameController.text,
      'description': descriptionController.text,
      'price': price,
      //'imageurl': imageurl,
    });

    // Clear the text fields and imageurl after adding the product
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    // setState(() {
    //   imageurl = null;
    //});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product Added", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );

    print("Product added to Firestore");
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductListScreen()),
    );
  } else {
    print("Please fill in all fields and add an image.");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
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
           
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () {
                _addProductToFirestore(); // Add the product to Firestore
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
                onPrimary: Colors.black,
              ),
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
