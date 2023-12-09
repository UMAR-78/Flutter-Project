import 'package:flutter/material.dart';
import 'package:adminportal/main.dart';
import 'package:adminportal/help.dart';
import 'package:adminportal/profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String UserId;

  CustomAppBar({required this.UserId});

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Remove back button
      backgroundColor: Color.fromARGB(255, 255, 230, 8),
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Image.asset(
              'assets/company_logo.png',
              width: 50.0, // Adjust the size of the company logo
            ),
          ),
          Text(
            'Saucy Eats',
            style: TextStyle(
              fontSize: 20, // Adjust the font size of Saucy Eats text
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.help, size: 20, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpInfoScreen()),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle, size: 20, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen(userId: UserId,)),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.logout, size: 20, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
        ),
      ],
    );
  }
}
