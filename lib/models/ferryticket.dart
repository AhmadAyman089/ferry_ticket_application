import 'dart:convert';

// This FerryTicket Class database model

//kita cuba je
class FerryTicket {
  final int? ticketId; // Ticket ID
  final DateTime departDate; // Departure date
  final String journey; // Journey
  final String departRoute; // Departure route
  final String destRoute; // Destination route
  final int? userId; // User ID

  FerryTicket({
    this.ticketId,
    required this.departDate,
    required this.journey,
    required this.departRoute,
    required this.destRoute,
    this.userId, required int bookId,
  });

  // Convert a FerryTicket object into a map. The keys correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'ticket_id': ticketId,
      'depart_date': departDate.toIso8601String(),
      'journey': journey,
      'depart_route': departRoute,
      'dest_route': destRoute,
      'user_id': userId,
    };
  }

  // Create a FerryTicket object from a map representation.
  factory FerryTicket.fromMap(Map<String, dynamic> map) {
    return FerryTicket(
      ticketId: map['ticket_id']?.toInt(),
      departDate: DateTime.parse(map['depart_date']),
      journey: map['journey'] ?? '',
      departRoute: map['depart_route'] ?? '',
      destRoute: map['dest_route'] ?? '',
      userId: map['user_id']?.toInt(),
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
    return 'FerryTicket(ticketId: $ticketId, departDate: $departDate, journey: $journey, '
        'departRoute: $departRoute, destRoute: $destRoute, userId: $userId)';
  }
}
