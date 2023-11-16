import 'dart:js';

import 'package:flutter/material.dart';
import 'package:saucy_eats/reuseable_widget/Image_widget.dart';
import 'package:saucy_eats/utils/colors_utils.dart';
import 'package:saucy_eats/screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: hexStringToColor("fffff")),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              70,
              10,
              60,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Center children horizontally and vertically
              children: <Widget>[
                logoWidget("assets/images/logo1.png"),
                SizedBox(height: 10),
                reuseableTextField("Enter Username", Icons.person_outline,
                    false, _emailTextController),
                SizedBox(height: 20),
                reuseableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(height: 10),
                SignInSignUpButton(context, true, () {}),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Row signUpOption() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Dont have an account?",
        style: TextStyle(
          color: hexStringToColor("fdca01"),
        ),
      ),
      // GestureDetector(
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => SignUpScreen(),
      //       ),
      //     );
      //   },
      //   child: Text(
      //     "Sign Up",
      //     style: TextStyle(
      //       color: hexStringToColor("fdca01"),
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
    ],
  );
}
