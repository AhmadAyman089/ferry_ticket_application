import 'package:ferry_ticket_application/models/ferryticket.dart';
import 'package:ferry_ticket_application/pages/BookingForm.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class BookingFormPage extends StatefulWidget {
  const BookingFormPage({Key? key, this.ferryticket})
  final FerryTicket? ferryticket;
  @override 
  State<BookingFormPage> createState() => _BookingFormPage();




}
class _BookingFormPage extends State<BookingFormPage> {

  DateTime  depart_date = DateTime.now();
  final TextEditingController _depart_dateController = TextEditingController();
  final TextEditingController _journeyController = TextEditingController();
  final TextEditingController _depart_routeController = TextEditingController();
  final TextEditingController _dest_routeController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();


  Future<void> _onSave() async {

    final departdate = _depart_dateController.text;
    final journey = _journeyController.text;
    final depart = _depart_routeController.text;
    final dest = _dest_routeController.text;

  widget.ferryticket == null
      ? await _databaseService
        .insertFerryTicket(FerryTicket(depart_date: departdate, journey: journey, depart_route: depart)
        )
        : await _databaseService.updateBrand(
            Brand(
              id: widget.brand!.id,
              name: name,
              description : description,
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

}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

