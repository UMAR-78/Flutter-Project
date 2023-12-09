import 'package:adminportal/cart.dart';
import 'package:adminportal/productforuser.dart';
import 'pizzaOnlylist.dart';
import 'burgerOnlylist.dart';
import 'package:flutter/material.dart';
import 'Widgets/UserAppBar.dart';

class HomePage extends StatelessWidget {
  final String did;

  HomePage({required this.did});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(UserId: did,),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/burger.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: TabBar(
                  tabs: [
                    Tab(text: 'Recommended'),
                    Tab(text: 'Pizza'),
                    Tab(text: 'Burger'),
                  ],
                  indicator: BoxDecoration(
                    color: Colors.yellow,
                  ),
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  indicatorWeight: 2.0,
                ),
                body: TabBarView(
                  children: [
                    buildProductList('Recommend', did),
                    buildProductList('Pizza', did),
                    buildProductList('Burger', did),
                  ],

                ),

             floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Navigate to CartScreen when FAB is pressed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartListUser(userId: did), // Replace CartScreen with your actual cart screen
          ),
        );
      },
      child: Icon(Icons.shopping_bag,color: Colors.black),
      backgroundColor: Colors.yellow, // Set the background color to yellow
    ),
  


    
              ),
            ),
          ),
        ],
      ),
    );
  }
Widget buildProductList(String category, String userId) {
  // Implement your logic to fetch and display the product list based on the category
  if (category == 'Recommend') {
    return ProductListUser(userId: userId);
  }else if(category=="Pizza")
  {
     return PizzaListUser(userId: userId);
  } else if(category=="Burger")
  {
    return BurgerListUser(userId: userId);
  }
  else {
    return Text('No products available for this category.');
  }
}
}