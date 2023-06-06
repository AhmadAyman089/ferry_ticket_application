import 'package:flutter/material.dart';
import 'package:ferry_ticket_application/pages/sign_in.dart';
//import 'package:ferry_ticket_application/pages/booking.dart';
//import'package:ferry_ticket_application/pages/booking_details.dart';
import 'package:ferry_ticket_application/services/database_service.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool loginError = false;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/ferrylogo.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Please login to view your bookings',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: handleLogin,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Don't have an account?"),
                  TextButton(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SigninForm()),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> handleLogin() async {
    final db = DatabaseService();
    bool isLoginValid =
        await db.checkUserLogin(nameController.text, passwordController.text);

    if (isLoginValid == true) {
      String userID =
          await db.getUserID(nameController.text, passwordController.text);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userID: userID)),
      );

      //TODO: Replace ViewBookingForm with the screen where you can manage bookings.

      return true;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text('Invalid username or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      return false;
    }
  }
}
