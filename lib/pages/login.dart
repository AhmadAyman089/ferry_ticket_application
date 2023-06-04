import 'package:flutter/material.dart';
import 'package:ferry_ticket_application/pages/sign_in.dart';
import 'package:ferry_ticket_application/pages/booking.dart';
//import'package:ferry_ticket_application/pages/booking_details.dart';
import 'package:ferry_ticket_application/services/database_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _MyLoginForm();
}

class _MyLoginForm extends State<LoginForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool loginError = false;
    return Padding(
        padding: const EdgeInsets.all(0),
        child: ListView(children: <Widget>[
          AppBar(
            title: Text('TravelWithFerry',
                style: TextStyle(color: Colors.white, fontSize: 35)),
            backgroundColor: Colors.pink,
          ),
          Container(
              color: Colors.white,
              height: 200.0,
              child: Image.asset('assets/ferrylogo.jpg')),
          Container(
              alignment: Alignment.center,
              child: const Text(
                'Please login to view your bookings',
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'UserName',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(height: 10),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      MaterialPageRoute(builder: (context) => SigninForm()),
                    );
                  }),
            ],
          )
        ]));
  }

  Future<bool> handleLogin() async {
    final db = DatabaseService();
    bool isLoginValid =
        await db.checkUserLogin(nameController.text, passwordController.text);

    if (isLoginValid == true) {
      String userID =
          await db.getUserID(nameController.text, passwordController.text);
      //await Navigator.pushReplacement(
        //context,
       // MaterialPageRoute(builder: (context) => Bookings(userID: userID)),

      //);

      //TODO: Replace ViewBookingForm with the screen where you can manage bookings.
      return true;
    } else {
      print("Try again!");
      return false;
    }
  }
}
