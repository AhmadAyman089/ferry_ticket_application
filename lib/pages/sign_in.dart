import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ferry_ticket_application/models/user.dart';
import 'package:ferry_ticket_application/services/database_service.dart';


import 'home_page.dart';
import 'login.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  State<SigninForm> createState() => _MySigninForm();
}

class _MySigninForm extends State<SigninForm> {


  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListView(
      children: <Widget>[
        AppBar(
          title: Text('Sign Up',
              style: TextStyle(color: Colors.white, fontSize: 35)),
          backgroundColor: Colors.pink,
        ),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Register',
              style: TextStyle(fontSize: 20),
            )),
        TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.account_circle),
            hintText: 'Select an Username',
            labelText: 'Username',
          ),
        ),
        TextFormField(
          controller: fNameController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.person),
            hintText: 'Enter your first name',
            labelText: 'First name',
          ),
        ),
        TextFormField(
          controller: lNameController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.person),
            hintText: 'Enter your Last Name',
            labelText: 'Last name',
          ),
        ),
        Container(
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.password_rounded),
              labelText: 'Password',
            ),
          ),
        ),
        TextFormField(
          controller: mobileController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.phone),
            hintText: 'Enter a phone number',
            labelText: 'Phone',
          ),
        ),
        Container(height: 10),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Register & Go to login'),
              onPressed: () {
                var newUser = User(
                    userId: Random.secure().nextInt(100),
                    firstName: fNameController.text,
                    lastName: lNameController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                    mobileNumber: mobileController.text);
                final db = DatabaseService();
                db.insertUser(newUser);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>  LoginPage()));
              },
            )),
      ],
    ));
  }
}
