import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfileScreen extends StatefulWidget {
  final String userId;

  MyProfileScreen({required this.userId});

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late TextEditingController _fnameController;
  late TextEditingController _lnameController;
  late TextEditingController _emailController;
  late TextEditingController _professionController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with user data from Firestore
    _fnameController = TextEditingController();
    _lnameController = TextEditingController();
    _emailController = TextEditingController();
    _professionController = TextEditingController();

    // Load user data from Firestore
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _fnameController.text = userData['firstname'] ?? '';
          _lnameController.text = userData['lastname'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _professionController.text = userData['contact'] ?? '';
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> saveChanges() async {
    try {
      // Update user data in Firestore
      await FirebaseFirestore.instance.collection('user').doc(widget.userId).update({
        'firstname': _fnameController.text,
        'lastname': _lnameController.text,
        'email': _emailController.text,
        'contact': _professionController.text,
      });

      // Show a success message
     ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Changes saved successfully',style:TextStyle(color:  Colors.black) ,),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.yellow,
  ),
);

    } catch (e) {
      print("Error saving changes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _fnameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _lnameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _professionController,
              decoration: InputDecoration(labelText: 'Contact'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
                onPrimary: Colors.black,
              ),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

