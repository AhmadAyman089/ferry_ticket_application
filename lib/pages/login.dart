import 'package:flutter/material.dart';
import 'package:ferry_ticket_application/pages/sign_in.dart';
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
    bool loginError = false; //Flag to indicate if there is a login error

    return Scaffold(
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/ferrylogo.png',
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Please login to view your bookings',
                        style: TextStyle(fontSize: 20),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(height: 10),
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: handleLogin,
                      )),
                  Row(
                    children: <Widget>[
                      const Text('Does not have account?'),
                      TextButton(
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SigninForm()),
                            );
                          }),
                    ],
                  )
                ])));
  }

  Future<bool> handleLogin() async {
    final db = DatabaseService();
    // Check if the login is valid by calling checkUserLogin method from the DatabaseService
    bool isLoginValid =
        await db.checkUserLogin(nameController.text, passwordController.text);

    if (isLoginValid == true) {
      // if login is valid
      String userID =
          await db.getUserID(nameController.text, passwordController.text);
      // Navigate to the HomePage, passing the userID as a parameter
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
