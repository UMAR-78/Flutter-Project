import 'package:adminportal/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup.dart';
import 'viewProduct.dart';

void main() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
       apiKey: "AIzaSyCgEfnRda2IeZIaefrswocQMzGEIAxWYtQ",
  authDomain: "saucy-eats.firebaseapp.com",
  projectId: "saucy-eats",
  storageBucket: "saucy-eats.appspot.com",
  messagingSenderId: "718492132529",
  appId: "1:718492132529:web:528225b8b618139613ee90",
  measurementId: "G-XY5C37VYNL"
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreen(),
        debugShowCheckedModeBanner: false,
    );
  }
}



class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
bool showPassword = false;


  Future<void> signIn(BuildContext context) async {
    try {
      // Perform a simple username-password check (replace this with your actual authentication logic)
      bool isCredentialsValid = await checkCredentials(
        username: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );

      if (isCredentialsValid) {
        // Now, query Firestore to get the document ID associated with the provided username
       QuerySnapshot userSnapshot = await FirebaseFirestore.instance
    .collection('user') // Replace with your actual collection name
    .where('email', isEqualTo: emailTextController.text.trim())
    .where('password', isEqualTo: passwordTextController.text.trim())
    .get();


        if (userSnapshot.docs.isNotEmpty) {
          String userDocumentId = userSnapshot.docs.first.id;
          print('hiii'+userDocumentId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(did: userDocumentId),
            ),
          );
            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Successfully", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.yellow ,
        ),
      );
        } else {
          // Handle the case where the user is not found in the Firestore collection
          print("Error: User not found in the 'users' collection");
             ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User not found", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor:  Colors.redAccent ,
        ),
      );
        }
      } else {
        // Handle the case where the provided credentials are invalid
        print("Error: Invalid credentials");
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid Credentials", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 4),
          backgroundColor:  Colors.redAccent ,
        ),
      );
      }
    } catch (e) {
      print("Error: $e");
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e", style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 4),
          backgroundColor:  Colors.redAccent ,
        ),
      );
    }
  }

  // Simulated authentication logic
  Future<bool> checkCredentials({required String username, required String password}) async {
    // Replace this with your actual authentication logic
    // For simplicity, always return true in this example
    return true;
  }



     @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:AppBar(
  title: Text(
    'Saucy Eats',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    textAlign: TextAlign.center,
  ),
  backgroundColor: Colors.yellow,
  centerTitle: true,
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
                controller: emailTextController,
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordTextController,
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
                  if(passwordTextController.text=='123' && emailTextController.text=='admin')
                  {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListScreen()),
                  ); 
                  } 
                  else{
                    signIn(context);
                  }             
                },
                style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
                onPrimary: Colors.black,
              ),
                child: Text('Sign In'),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigate to the SignUpScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}