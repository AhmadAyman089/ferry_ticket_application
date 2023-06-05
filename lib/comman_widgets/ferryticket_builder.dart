import 'package:ferry_ticket_application/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ferry_ticket_application/models/ferryticket.dart';
import 'package:ferry_ticket_application/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FerryTicketBuilder extends StatelessWidget {
  const FerryTicketBuilder({
    Key? key,
  required this.future,
  required this.onEdit,
  required this.onDelete,


    }) : super(key: key);
  final Future<List<FerryTicket>> future;
  final Function(FerryTicket) onEdit;
  final Function(FerryTicket) onDelete;
  Future<String> getFistName(int id) async {
  final DatabaseService _databaseService = DatabaseService();
  final user = await _databaseService.user(id);
  
  return user.firstName;

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FerryTicket>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final ferryticket = snapshot.data![index];
              return _buildFerryTicketeCard(ferryticket, context);
            },
          ),
        );
      },
    );
  }

Widget _buildFerryTicketeCard (FerryTicket ferryTicket, BuildContext context) {
  return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: const FaIcon(FontAwesomeIcons.gifts, size: 18.0),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ferryTicket.depart_route,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future: getFistName(ferryTicket.user_id),
                    builder: (context, snapshot) {
                      return Text('User Id : ${snapshot.data}');
                    },
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('Depaty date: ${ferryTicket.depart_date.toString()}, Route: ${ferryTicket.depart_route.toString()} '),
                      
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onEdit(ferryTicket),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.edit, color: Colors.orange[800]),
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onDelete(ferryTicket),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.delete, color: Colors.red[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

