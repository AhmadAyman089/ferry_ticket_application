import 'package:ferry_ticket_application/models/ferryticket.dart';
import 'package:ferry_ticket_application/pages/BookingForm.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class BookingFormPage extends StatefulWidget {
  const BookingFormPage({Key? key, this.ferryticket})  : super(key: key);
  final FerryTicket? ferryticket;
  @override 
  State<BookingFormPage> createState() => _BookingFormPage();

}


class _BookingFormPage extends State<BookingFormPage> {

  DateTime  depart_date = DateTime.now();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _depart_dateController = TextEditingController();
  final TextEditingController _journeyController = TextEditingController();
  final TextEditingController _depart_routeController = TextEditingController();
  final TextEditingController _dest_routeController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

 static const List<String> list = <String>['Penang', 'Langkawi', 'Singapore', 'Koh Lipe'];

  Future<void> _onSave() async {

    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;

    final depart_date = _depart_dateController.text;
    final journey = _journeyController.text;
    final depart_route = _depart_routeController.text;
    final dest_route = _dest_routeController.text;

  widget.ferryticket == null
      ? await _databaseService
        .insertFerryTicket(FerryTicket(depart_date: depart_date, journey: journey, depart_route: depart_route, dest_route: dest_route, user_id: firstName.)
        )
        : await _databaseService.updateBooking(
            FerryTicket(depart_date: depart_date, journey: journey, depart_route: depart_route, dest_route: dest_route, user_id: user_id!)(
             
            ),
          );
    Navigator.pop(context);
  }
  String? errorMessage;

  Future<void> _selectDepartureTime(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: depart_date,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );

  Future<void> _onSave() async {
    final name = _nameController.text;
    final size1 = _selectedSize;
    final color = _colors[_selectedColor];
    final brand = _brands[_selectedBrand];
    // Add save code here
    widget.shoe == null
        ? await _databaseService.insertShoe(
            Shoe(name: name, size1: size1, color: color, brandId: brand.id!),
          )
        : await _databaseService.updateShoe(
            Shoe(
              id: widget.shoe!.id,
              name: name,
              size1: size1,
              color: color,
              brandId: brand.id!,
            ),
          );
    Navigator.pop(context);
  }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Shoe Record'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter type of the shoe here',
              ),
            ),
            const SizedBox(height: 16.0),
            // Size Slider
            SizeSlider(
              max: 30.0,
              selectedSize: _selectedSize.toDouble(),
              onChanged: (value) {
                setState(() {
                  _selectedSize = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16.0),
            // Color Picker
            ColorPicker(
              colors: _colors,
              selectedIndex: _selectedColor,
              onChanged: (value) {
                setState(() {
                  _selectedColor = value;
                });
              },
            ),
            const SizedBox(height: 24.0),
            // Brand Selector
            FutureBuilder<List<Brand>>(
              future: _getBrands(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading brands...");
                }
                return BrandSelector(
                  brands: _brands.map((e) => e.name).toList(),
                  selectedIndex: _selectedBrand,
                  onChanged: (value) {
                    setState(() {
                      _selectedBrand = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: const Text(
                  'Save the Shoe data',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
