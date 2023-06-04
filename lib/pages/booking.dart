import 'package:flutter/material.dart';
import 'package:ferry_ticket_application/services/database_service.dart';

import 'home_page.dart';

class Bookings extends StatefulWidget {
  final String userID;
  const Bookings({required this.userID});
  @override
  State<Bookings> createState() => _Bookings();
}

class _Bookings extends State<Bookings> {
  var trips = [];
  var bookingIDs = [];

  @override
  void initState() {
    super.initState();
  }

  Future GetListingData() async {
    final db = DatabaseService();
    var bookingdata = await db.findAllBookings(widget.userID);

    var lengthOfBookingData = bookingdata.length;
    for (int i = 0; i < bookingdata.length; i++) {
      String singleTitle = "From " +
          bookingdata.elementAt(i).entries.elementAt(3).value.toString() +
          " to " +
          bookingdata.elementAt(i).entries.elementAt(4).value.toString();
      String bookingNr =
          bookingdata.elementAt(i).entries.elementAt(0).value.toString();
      trips.add(singleTitle);
      bookingIDs.add(bookingNr);
    }
    print(lengthOfBookingData);
    return "success";
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          title: Text('MyFerryKL',
          style: TextStyle(color: Colors.white, fontSize: 35)),
          backgroundColor: Colors.blue,),
        body: Column(
        children: [
        FutureBuilder(
        future: GetListingData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
                child: ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Column(children: [
                            ListTile(
                              title: Text(trips[index]),
                              subtitle: Text("Booking number: "+ bookingIDs[index]),
                              leading: Icon(Icons.directions_boat_outlined,
                                  color: Colors.blue.shade400),
                            ),
                            ElevatedButton(
                              child: const Text('View Booking'),
                              onPressed: () {

                                print(bookingIDs[index]);
                                //Navigator.pushReplacement(context,
                  // MaterialPageRoute(builder: (context) => ViewBookingForm(userID: widget.userID, bookingId: bookingIDs[index])));


                              },
                            )
                          ]));
                    }));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    Center(
    child: ButtonBar(
    alignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      ElevatedButton(
        child: const Text('New Booking'),
        onPressed: () {
         // Navigator.pushReplacement(context,
             // MaterialPageRoute(builder: (context) => BookingForm(userID: widget.userID,)));
        },
      ),
      ElevatedButton(
        child: const Text('Logout'),
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MyHomePage()));
        },
      )]))
    ]));
  }
}
