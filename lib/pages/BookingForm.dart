import 'dart:ffi';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../models/ferryticket.dart';
import '../services/database_service.dart';
import 'Booking.dart';


// Create a Form widget.
class BookingForm extends StatefulWidget {
  
  final String userID;

  const BookingForm({required this.userID});
  @override
  BookingFormState createState() {
    return BookingFormState();
  }
}


// Create a corresponding State class. This class holds data related to the form.
class BookingFormState extends State<BookingForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateInput = TextEditingController();

  String dropdownvalue1 = 'Kuala Lumpur';
  String dropdownvalue2 = 'Johor';

  // List of items in our dropdown menu
  var items = [
    'Kuala Lumpur',
    'Johor',
    'Penang',
    'Langkawi',
    'Malacca',
    'Jakarta',
    'Singapore',
    'Dumai',
  ];

  bool _checkbox = false;
  bool _checkboxListTile = false;

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          AppBar(
          title: Text('MyFerryKL',
              style: TextStyle(color: Colors.white, fontSize: 35)),
          backgroundColor: Colors.blue,),
              Text(
                "New Booking",
                style:
                    Theme.of(context).textTheme.headline5, // like <h1> in HTML
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your name',
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your Surname',
                  labelText: 'Surname',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Enter a phone number',
                  labelText: 'Phone',
                ),
              ),
              Container(
                  child: TextField(
                controller: dateInput,
                //editing controller of this TextField
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Enter Date" //label text of field
                    ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dateInput.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              )),
              SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 40.0),
                  child: Text('Departing From')),
              Container(
                  margin: const EdgeInsets.only(left: 40.0),
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue1,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue1 = newValue!;
                      });
                    },
                  )),
              SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 40.0),
                  child: Text('Arriving at')),
              Container(
                  margin: const EdgeInsets.only(left: 40.0),
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue2,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue2 = newValue!;
                      });
                    },
                  )),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('One way'),
                  value: _checkbox,
                  onChanged: (value) {
                    setState(() {
                      _checkbox = !_checkbox;
                    });
                  },
                ),
              ),
        ButtonBar(
            alignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
                  ElevatedButton(
                    child: Text('Confirm Booking'),
                    onPressed: (){
                      var newTicket = new FerryTicket(book_id: Random.secure().nextInt(999), depart_date: DateTime.parse(dateInput.text), journey: _checkbox.toString(), depart_route: dropdownvalue1, dest_route: dropdownvalue2, user_id: int.parse(widget.userID));
                      DatabaseService().insertFerryTicket(newTicket);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder:
                              (context) => Bookings(userID:widget.userID )
                          ));
                    },
                  ),
              ElevatedButton(
                child: Text('Back to Bookings'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Bookings(userID: widget.userID)));
                },
              ),]
        ),
            ],
          ),
        ));
  }
}
