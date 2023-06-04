import 'dart:convert';

// This FerryTicket Class database model

//kita cuba je
class FerryTicket {
  final int? book_id; // Ticket ID
  final DateTime depart_date; // Departure date
  final String journey; // Journey
  final String depart_route; // Departure route
  final String dest_route; // Destination route
  final int user_id; // User ID

   FerryTicket({
    this.book_id,
    required this.depart_date,
    required this.journey,
    required this.depart_route,
    required this.dest_route,
    required this.user_id, 
    

  });

  // Convert a FerryTicket object into a map. The keys correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'ticket_id': book_id,
      'depart_date': depart_date.toIso8601String(),
      'journey': journey,
      'depart_route': depart_route,
      'dest_route': dest_route,
      'user_id': user_id,
    };
  }

  // Create a FerryTicket object from a map representation.
  factory FerryTicket.fromMap(Map<String, dynamic> map) {
    return FerryTicket(
      book_id: map['ticket_id']?.toInt() ?? 0,
      depart_date: DateTime.parse(map['depart_date']),
      journey: map['journey'] ?? '',
      depart_route: map['depart_route'] ?? '',
      dest_route: map['dest_route'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
    

    );
  }

  // Convert a FerryTicket object into a JSON string.
  String toJson() => json.encode(toMap());

  // Create a FerryTicket object from a JSON string.
  factory FerryTicket.fromJson(String source) =>
      FerryTicket.fromMap(json.decode(source));

  // Override the toString method to provide a string representation of a FerryTicket object.
  @override
  String toString() {
    return 'FerryTicket(ticketId: $book_id, departDate: $depart_date, journey: $journey, '
        'departRoute: $depart_route, destRoute: $dest_route, userId: $user_id)';
  }
}
