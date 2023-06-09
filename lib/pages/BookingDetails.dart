import 'dart:math';

import 'package:ferry_ticket_application/models/ferryticket.dart';
import 'package:ferry_ticket_application/models/user.dart';
import 'package:ferry_ticket_application/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';

class BookingFormPageEdit extends StatefulWidget {
  final String userID; //user ID associated with the booking form
  final FerryTicket? ferryTicket; //optional ferry ticket data
  const BookingFormPageEdit({Key? key, required this.userID, this.ferryTicket})
      : super(key: key);

  @override
  State<BookingFormPageEdit> createState() => _BookingFormPageEditState();
}

class _BookingFormPageEditState extends State<BookingFormPageEdit> {
  final _formKey = GlobalKey<FormState>(); //key for the form widget

  //controllers for various form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _departDateController = TextEditingController();
  DateTime departureDate = DateTime.now();

  final TextEditingController _journeyController = TextEditingController();
  final TextEditingController _departRouteController = TextEditingController();
  final TextEditingController _destRouteController = TextEditingController();

  bool _oneWayCheckbox = false; //Represents the state of the one-way checkbox
  bool _returnCheckbox = false; //Represents the state of the return checkbox

  final DatabaseService _databaseService = DatabaseService();

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          departureDate, //Initial date set to the current departureDate value
      firstDate: DateTime(1900), // The earliest selectable date
      lastDate: DateTime(2100), //The latest selectable date
    );
    if (picked != null) {
      setState(() {
        departureDate =
            picked; // Update the departureDate with the selected date
        _departDateController.text =
            DateFormat('yyyy-MM-dd').format(departureDate);
        // Update the text value of the departDateController with the formatted date
      });
    }
  }

  Future<void> _onSave() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final mobileNumber = _mobileNumberController.text;

    final departDate = _departDateController.text;

    final journey = _journeyController.text;
    final departRoute = _departRouteController.text;
    final destRoute = _destRouteController.text;

    // Check if widget.ferryTicket is null to determine if it's a new ticket or an update
    widget.ferryTicket == null
        ? await _databaseService.insertFerryTicket(
            FerryTicket(
              bookId: Random.secure().nextInt(999), // Generate a random bookId
              departDate: DateTime.parse(departDate),
              journey: journey,
              departRoute: departRoute,
              destRoute: destRoute,
              userId: int.parse(widget.userID),
            ),
          )
        : await _databaseService.updateBooking(
            FerryTicket(
              bookId: widget.ferryTicket!.bookId,
              departDate: DateTime.parse(departDate),
              journey: journey,
              departRoute: departRoute,
              destRoute: destRoute,
              userId: int.parse(widget.userID),
            ),
          );

    Navigator.pop(
        context); // Close the current page and go back to the previous page
  }

  String dropdownvalue1 = 'Penang'; // Default value for the first dropdown
  String dropdownvalue2 = 'Koh Lipe'; // Default value for the second dropdown
  var destinations = [
    'Penang',
    'Langkawi',
    'Singapore',
    'Koh Lipe',
  ];
  @override
  void initState() {
    super.initState();

    // Update form fields based on the ferry ticket data
    if (widget.ferryTicket != null) {
      final ferryTicket = widget.ferryTicket!;
      _departRouteController.text = ferryTicket.departRoute;
      _destRouteController.text = ferryTicket.destRoute;
      departureDate = ferryTicket.departDate; 

      setState(() {
        dropdownvalue1 = ferryTicket.departRoute;
        dropdownvalue2 = ferryTicket.destRoute;


 if (ferryTicket.journey == 'One way') {
        _oneWayCheckbox = true;
        _returnCheckbox = false;
      } else if (ferryTicket.journey == 'Return') {
        _oneWayCheckbox = false;
        _returnCheckbox = true;
      }
        
      }
      );
    }

    // Fetch user data from the database and update form fields
    int userId = int.tryParse(widget.userID) ??
        0; // Convert to int, default to 0 if parsing fails
    DatabaseService().user(userId).then((User user) {
      if (user != null) {
        setState(() {
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _mobileNumberController.text = user.mobileNumber;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = destinations.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Ferry Ticket'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _mobileNumberController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Depart Date'),
                  TextButton(
                    onPressed: () => _selectCheckInDate(context),
                    child: Text("${departureDate.toLocal()}".split(' ')[0]),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('One way'),
                  value: _oneWayCheckbox,
                  onChanged: (value) {
                    setState(() {
                      _oneWayCheckbox = value!;
                      _returnCheckbox = false; // Uncheck the return checkbox
                      _journeyController.text =
                          'One way'; // Update the journey controller text
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Return'),
                  value: _returnCheckbox,
                  onChanged: (value) {
                    setState(() {
                      _returnCheckbox = value!;
                      _oneWayCheckbox = false; // Uncheck the one way checkbox
                      _journeyController.text =
                          'Return'; // Update the journey controller text
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Depart'),
              DropdownButton(
                value: dropdownvalue1,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                items: destinations.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownvalue1 = value!;
                    _departRouteController.text = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Destination'),
              DropdownButton(
                value: dropdownvalue2,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                items: destinations.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownvalue2 = value!;
                    _destRouteController.text = value;
                  });
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _onSave,
                child: const Text(
                  'Save Ferry Ticket',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ElevatedButton(
                child: Text('Back'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage(userID: widget.userID)));
                },
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}
