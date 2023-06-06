import 'package:ferry_ticket_application/comman_widgets/ferryticket_builder.dart';
import 'package:ferry_ticket_application/pages/BookingDetails.dart';
import 'package:ferry_ticket_application/pages/bookingFormPage.dart';
import 'package:ferry_ticket_application/pages/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ferry_ticket_application/models/ferryticket.dart';
import 'package:ferry_ticket_application/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final String userID; //get user id
  const HomePage({Key? key, required this.userID}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<FerryTicket>> _getFerryTicket() async {
    return await _databaseService.ferryTicket();
  }

  Future<void> _onFerryTicketDelete(FerryTicket ferryTicket) async {
    await _databaseService.deleteBooking(ferryTicket.bookId!);
    setState(() {});
  }

  @override
  //Widget build ferry ticket
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ferry Ticket '),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('User ID: ${widget.userID}'),

              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // This one dislay booking
            FerryTicketBuilder(
              future: _getFerryTicket(),
              onEdit: (value) {
                {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute( // Nav to bookingformEdit
                          builder: (_) => BookingFormPageEdit(
                            ferryTicket: value,
                            userID: widget.userID,
                          ),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                }
              },
              onDelete: _onFerryTicketDelete, // Delet
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context) // Nav to bookingfrompage
                    .pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BookingFormPage(
                          userID: widget.userID,
                        ),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              }, 
              heroTag: 'addBooking',
              child: const FaIcon(FontAwesomeIcons.ticket), //Ticket icon
            ),
            ElevatedButton( 
              child: Icon(Icons.logout_rounded), // Icon for log out
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}
