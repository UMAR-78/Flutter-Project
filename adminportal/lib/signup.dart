import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}


class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
bool showPassword=false;

Future<void> _addUserToFirestore() async {
  bool isEmailValid = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(_emailTextController.text);
  bool isContactValid = _contactController.text.length == 11;
  bool isPasswordValid = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$').hasMatch(_passwordTextController.text);

  if (_emailTextController.text.isNotEmpty &&
      _passwordTextController.text.isNotEmpty &&
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _contactController.text.isNotEmpty) {
         
    if (isEmailValid && isContactValid && isPasswordValid) {
      // Your existing Firestore code...
      await FirebaseFirestore.instance.collection('user').add({
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'contact': _contactController.text,
        'email':_emailTextController.text,
        'password':_passwordTextController.text,
        //'imageurl': imageurl,
      });

      _firstNameController.clear();
      _lastNameController.clear();
      _contactController.clear();
      _emailTextController.clear();
      _passwordTextController.clear();

      print("User added to Firestore");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User added to Firestore", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
      Navigator.pop(context);
    }
    else{
      // Concatenate success and error messages
      String message = '';

      String errorMessage = '';
    
      if (!isEmailValid) {
        errorMessage = 'Invalid email format.\n';
      }

      if (!isContactValid) {
        errorMessage += 'Contact must be 11 characters long.\n';
      }

      if (!isPasswordValid) {
        errorMessage += 'Password must be at least 8 characters long and include letters, numbers, and symbols.';
      }

      message += errorMessage;

      // Show a single SnackBar with both success and error messages
      
    
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 4),
          backgroundColor:  Colors.redAccent,
        ),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          'Sign Up',
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
        decoration: BoxDecoration(
          // Your decoration here
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                "assets/company_logo.png",
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: "First Name",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: "Contact",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailTextController,
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            
              SizedBox(height: 10),
              TextField(
                controller:_passwordTextController,
                obscureText: !showPassword, // Toggle obscureText based on showPassword
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addUserToFirestore();
                },
                style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
                onPrimary: Colors.black,
              ),
                child: Text(
                  'Sign Up'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
