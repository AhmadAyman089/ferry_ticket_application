import 'dart:convert';

class User {
  final int? userId; // User ID
  final String firstName; // First name
  final String lastName; // Last name
  final String username; // Username
  final String password; // Password
  final String mobileNumber; // Mobile number

  User({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.mobileNumber,
  });

  // Convert a User object into a map. The keys correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'f_name': firstName,
      'l_name': lastName,
      'username': username,
      'password': password,
      'mobilehp': mobileNumber,
    };
  }

  // Create a User object from a map representation.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id']?.toInt() ?? 0,
      firstName: map['f_name'] ?? '',
      lastName: map['l_name'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      mobileNumber: map['mobilehp'] ?? '',
    );
  }

  // Convert a User object into a JSON string.
  String toJson() => json.encode(toMap());

  // Create a User object from a JSON string.
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  // Override the toString method to provide a string representation of a User object.
  @override
  String toString() {
    return 'User(userId: $userId, firstName: $firstName, lastName: $lastName, '
        'username: $username, password: $password, mobileNumber: $mobileNumber)';
  }
}
