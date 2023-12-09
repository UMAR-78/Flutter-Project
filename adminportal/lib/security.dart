import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecurityScreen extends StatefulWidget {
  final String userId;

  SecurityScreen({required this.userId});

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool showCurrentPassword = false;
  bool showNewPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Security',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            TextField(
              controller: currentPasswordController,
              obscureText: !showCurrentPassword,
              decoration: InputDecoration(
                labelText: "Current Password",
                filled: true,
                fillColor: Colors.white.withOpacity(0.3),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      showCurrentPassword = !showCurrentPassword;
                    });
                  },
                  child: Icon(
                    showCurrentPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: !showNewPassword,
              decoration: InputDecoration(
                labelText: "New Password",
                filled: true,
                fillColor: Colors.white.withOpacity(0.3),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      showNewPassword = !showNewPassword;
                    });
                  },
                  child: Icon(
                    showNewPassword ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updatePassword();
              },
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

  Future<void> updatePassword() async {
    try {
      // Validate the current password (you may want to add more validation logic)
      String currentPassword = currentPasswordController.text.trim();
      String newPassword = newPasswordController.text.trim();

      // Query Firestore to get the user document
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .get();

      if (userSnapshot.exists) {
        // Validate the current password
        String storedPassword = userSnapshot.get('password');

        if (currentPassword == storedPassword) {
          // Update the password in Firestore
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.userId)
              .update({'password': newPassword});

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Save Successfully", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
        } else {
          // Show error message if the current password is invalid
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid Password", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
        }
      } else {
        // Show error message if the user document is not found
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User not found", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
      }
    } catch (e) {
      // Handle errors
      print("Error: $e");
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
    }
  }
}
