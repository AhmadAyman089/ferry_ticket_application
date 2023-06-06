import 'dart:convert';

// This is FerryTicket Class database model

class FerryTicket {
  final int? bookId; // Ticket ID
  final DateTime departDate; // Departure date
  final String journey; // Journey
  final String departRoute; // Departure route
  final String destRoute; // Destination route
  final int userId; // User ID

  //constructor for the FerryTicket class
  FerryTicket({
    this.bookId,
    required this.departDate,
    required this.journey,
    required this.departRoute,
    required this.destRoute,
    required this.userId,
  });

  // Convert a FerryTicket object into a map. The keys correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'book_id': bookId,
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
      bookId: map['book_id']?.toInt() ?? 0,
      departDate: DateTime.parse(map['depart_date'] ?? ''),
      journey: map['journey'] ?? '',
      departRoute: map['depart_route'] ?? '',
      destRoute: map['dest_route'] ?? '',
      userId: map['user_id']?.toInt() ?? 0,
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
    return 'FerryTicket(book_id: $bookId, depart_date: $departDate, journey: $journey, '
        'depart_route: $departRoute, dest_route: $destRoute, user_id: $userId)';
  }
}
