import 'package:adminportal/deleteAccount.dart';
import 'package:adminportal/iorderhistory.dart';
import 'package:adminportal/myfav.dart';
import 'package:adminportal/security.dart';
import 'package:adminportal/updateprofile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  ProfileScreen({required this.userId});
  
  
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            FullWidthButton(text: 'My Profile', onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyProfileScreen(userId: userId,)),
            );
            }),
            FullWidthButton(text: 'Privacy and Security', onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityScreen(userId: userId,)),
            );
            }),
            FullWidthButton(text: 'My Orders', onPressed: () {
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryScreen(userId: userId,)),
            );
            }),
            FullWidthButton(text: 'My Favorites', onPressed: () {
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoriteProductsScreen(userId: userId,)),
            );
            }),
            FullWidthButton(text: 'Delete Account', onPressed: () {
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeleteAccountDialog(userId: userId,)),
            );
            }),
          ],
        ),
      ),
    );
  }
}

class FullWidthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FullWidthButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.white,
          fixedSize: Size(double.infinity, 60),
        ),
      ),
    );
  }
}
