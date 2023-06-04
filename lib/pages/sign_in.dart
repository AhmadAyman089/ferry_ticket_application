import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ferry_ticket_application/models/user.dart';
import 'package:ferry_ticket_application/services/database_service.dart';


import 'login.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  State<SigninForm> createState() => _MySigninForm();
}

class _MySigninForm extends State<SigninForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListView(
      children: <Widget>[
        AppBar(
          title: Text('TravelWithFerry',
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
          controller: nameController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.person),
            hintText: 'Enter your name',
            labelText: 'Name',
          ),
        ),
        TextFormField(
          controller: surNameController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.person),
            hintText: 'Enter your Surname',
            labelText: 'Surname',
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
                    firstName: nameController.text,
                    lastName: surNameController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                    mobileNumber: mobileController.text);
                final db = DatabaseService();
                db.insertUser(newUser);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginForm()));
              },
            )),
      ],
    ));
  }
}
