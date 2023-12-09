import 'package:adminportal/main.dart';
import 'package:flutter/material.dart';
//import 'package:adminportal/addproduct.dart';
import 'package:adminportal/viewProduct.dart';
import 'package:adminportal/order.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 255, 230, 8),
      title: Text(
        'Saucy Eats',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      leading: PopupMenuButton<String>(
        icon: Icon(Icons.menu),
        onSelected: (value) {
          // Handle the selected menu item here
          if(value=='Manage Products')
          {
            Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductListScreen()),
                    );
          }
          if(value=='Manage Orders')
          {
            Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  OrderControlScreen()),
                    );
           
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'Manage Products',
            child: Text('Manage Products'),
          ),
          PopupMenuItem<String>(
            value: 'Manage Orders',
            child: Text('Manage Orders'),
          ),
          // Add more menu items as needed
        ],
        color: Color.fromARGB(214, 218, 217, 206), // Set the background color of the menu
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(
            'assets/company_logo.png',
            width: 100.0,
          ),
        ),
         IconButton(
          icon: Icon(Icons.logout,color: Colors.black),
          onPressed: () {
             Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  SignInScreen()),
                    );
            // Handle logout logic here
            // For example, you can show a confirmation dialog and then log out the user.
          },
        ),
      ],
    );
  }
}
