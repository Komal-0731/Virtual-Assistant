import 'package:flutter/material.dart';
class SignupScreen extends StatefulWidget{

  @override
  _SignupScreenState createState() => _SignupScreenState();
 
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _registerUser() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty ){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content:Text('Please fill all fields')));
       return;
      }
    if (!email.endsWith('@dattakala.edu.in')){
      ScaffoldMessenger.of(context)
          .showSnackBar( SnackBar(content:Text('Email must end with @dattakala.edu.in')));
    }
    if(password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password must be at least 6 characters')));
      return;
    }
    if (password != confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')));
      return;
    }

  ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(content: Text('Account created successfully!')),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sign Up')),
    body:Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: _passwordController,obscureText: true,
                       decoration: InputDecoration(labelText: "Password"),),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(controller: _confirmPasswordController,obscureText: true,
                decoration: InputDecoration(labelText: "Confirm Password"),),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed:_registerUser,
                          child: Text("Create Account")),
          ),
          TextButton(onPressed: ()=>Navigator.pushReplacementNamed(context, '/login'),
                        child: Text("Already have an account ? Login"),
          )
        ],
        ),
      )
    )
    );
  }
}