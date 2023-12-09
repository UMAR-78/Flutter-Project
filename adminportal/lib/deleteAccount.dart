import 'package:adminportal/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteAccountDialog extends StatelessWidget {
  final String userId;

  DeleteAccountDialog({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
          margin: EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Are you sure you want to delete your account? This action cannot be undone.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Delete user document from Firestore
                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(userId)
                          .delete();

                      // Navigate to the main screen after deletion
                 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
                    },
                    child: Text('DELETE'), style: ElevatedButton.styleFrom(
    primary: Colors.yellow,
    onPrimary: Colors.black ,// Set the background color here
  ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
