import 'package:ferry_ticket_application/models/ferryticket.dart';
import 'package:ferry_ticket_application/models/user.dart';
import 'package:ferry_ticket_application/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class BookingFormPage extends StatefulWidget {
  final String userID;

  const BookingFormPage({Key? key, required this.userID}) : super(key: key);

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _departDateController = TextEditingController();
  DateTime departureDate = DateTime.now();

  final TextEditingController _journeyController = TextEditingController();
  final TextEditingController _departRouteController = TextEditingController();
  final TextEditingController _destRouteController = TextEditingController();

  static const List<String> destinations = [
    'Penang',
    'Langkawi',
    'Singapore',
    'Koh Lipe'
  ];

  final DatabaseService _databaseService = DatabaseService();

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
  }

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final mobileNumber = _mobileNumberController.text;

      final departDate = _departDateController.text;
      final journey = _journeyController.text;
      final departRoute = _departRouteController.text;
      final destRoute = _destRouteController.text;

      final ferryTicket = FerryTicket(
        depart_date: DateTime.parse(departDate),
        journey: journey,
        depart_route: departRoute,
        dest_route: destRoute,
        user_id: int.parse(widget.userID),
      );

      await _databaseService.insertFerryTicket(ferryTicket);

      Navigator.pop(context);
    }
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
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _journeyController,
                decoration: const InputDecoration(labelText: 'Journey'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the journey';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Depart Route'),
              DropdownButton<String>(
                
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _departRouteController.text = value!;
                  });
                },
                hint: const Text('Select Departure Route'),
                items:
                    destinations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
               
              const SizedBox(height: 16.0),
              const Text('Destination Destination'),
              DropdownButton<String>(
                
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _destRouteController.text = value!;
                  });
                },
                hint: const Text('Select Destination Route'),
                items:
                    destinations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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

             Text('$departureDate'),             
            ],
          ),
        ),
      ),
    );
  }
}
