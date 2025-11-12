import 'package:flutter/material.dart';
import 'chat_screen.dart';


class LoginScreen extends StatefulWidget{

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>  {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void _loginUser() {
    // Validate credentials or connect Firebase
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>chatScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter valid credentials.')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => chatScreen()),
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight:FontWeight.bold),)),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(controller:_emailController,
                            decoration: InputDecoration(labelText:"Email",
                                prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder()),
                    //Email Validation logic

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(controller: _passwordController,
                            decoration: InputDecoration(labelText: "Password",
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder())),
                ),
                ElevatedButton(onPressed: _loginUser,
                           child: Text("Login")),
                TextButton(onPressed: ()=> Navigator.pushReplacementNamed(context, '/signup'),
                           child: Text("Don’t have an account? Sign Up"))

              ],
            ),
          ),
        ),

    );

  }
}

