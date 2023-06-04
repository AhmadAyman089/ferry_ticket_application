import 'package:ferry_ticket_application/models/ferryticket.dart';
import 'package:ferry_ticket_application/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;

  //Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'ferrytick_app.db');
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  //create tables for user and ferryticket in the database
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {user} TABLE statement on the database.
    await db.execute('''
      CREATE TABLE user(
        user_id INTEGER PRIMARY KEY ,
        f_name VARCHAR(50) NOT NULL,
        l_name VARCHAR(50) NOT NULL,
        username VARCHAR(20) NOT NULL,
        password VARCHAR(20) NOT NULL,
        mobilehp VARCHAR(20) NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ferryticket(
        book_id INTEGER PRIMARY KEY,
        depart_date DATE NOT NULL,
        journey VARCHAR(10) NOT NULL,
        depart_route VARCHAR(20) NOT NULL,
        dest_route VARCHAR(20) NOT NULL,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL
      )
    ''');
  }

  // Define a function that insert user into the database
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Define a function that insert ferryticket into the database
  Future<void> insertFerryTicket(FerryTicket ferryTicket) async {
    final db = await _databaseService.database;
    await db.insert(
      'ferryticket',
      ferryTicket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> checkUserLogin(String username, String password) async {
    final db = await database;
    bool validLogin;

    //Execute a query on the "User" table to check if a matching username and password exist
    List<Map> loginQuery = await db.query("User",
        columns: ["username", "password"],
        where: "username = ? and password = ?",
        whereArgs: [username, password]);

    //If the query returns any rows, it means the login credentials are valid
    if (loginQuery.length > 0) {
      validLogin = true;
    } else {
      validLogin = false;
    }
    return validLogin; //Return a boolean value indicating if the login is valid or not
  }

  Future<String> getUserID(String username, String password) async {
    final db = await database;
    var userQuery = await db.query("user",
        columns: ["user_id"],
        where: "username = ? and password = ?",
        whereArgs: [username, password]);

    //Retrieve the first row from the query result and get the value of the "user_id" column
    String userid = userQuery.first.entries.first.value.toString();

    //Return the retrieved user ID as a string
    return userid;
  }

  Future<List> findUserInfo(String user_id) async {
    final db = await database;

    //Retrieve user information from the "user" table based on the provided user_id
    List<Map> userInfo = await db.rawQuery('''
      SELECT f_name,l_name,mobilehp FROM user where user_id = $user_id     ''');
    //Retrieve ticket information using the findAllBookings() function
    List<Map> ticketInfo = await findAllBookings(user_id);

    var userDataArray = [];
    // Iterate over the entries in the first row of the userInfo query result
    for (int i = 0; i < userInfo.elementAt(0).length; i++) {
      userDataArray
          .add(userInfo.elementAt(0).entries.elementAt(i).value.toString());
    }
    // Iterate over the entries in the first row of the ticketInfo query result
    for (int i = 0; i < ticketInfo.elementAt(0).length; i++) {
      userDataArray
          .add(ticketInfo.elementAt(0).entries.elementAt(i).value.toString());
    }

    return userDataArray; // Return the userDataArray containing user and ticket information
  }

  Future<List<Map>> findAllBookings(String user_id) async {
    final db = await database;

    //Retrieve ticket information from the "ferryticket" table where the user_id matches
    List<Map> ticket = await db.rawQuery('''
     SELECT * FROM  ferryticket where user_id =( SELECT $user_id FROM User)
     ''');

    return ticket; //Return the query result containing the ticket information as a List of Maps
  }

  Future<List> findSpecificBooking(String user_id, String bookingID) async {
    final db = await database;

    List<Map> userInfo = await db.rawQuery('''
      SELECT f_name,l_name,mobilehp FROM user where user_id = $user_id     ''');

    List<Map> specificTicketInfo = await db.rawQuery('''
     SELECT * FROM  ferryticket where user_id =$user_id and book_id =$bookingID
     ''');

    var userDataArray = [];
    for (int i = 0; i < userInfo.elementAt(0).length; i++) {
      userDataArray
          .add(userInfo.elementAt(0).entries.elementAt(i).value.toString());
    }
    for (int i = 0; i < specificTicketInfo.elementAt(0).length; i++) {
      userDataArray.add(specificTicketInfo
          .elementAt(0)
          .entries
          .elementAt(i)
          .value
          .toString());
    }

    return userDataArray;
  }

  Future<List<Map>> deleteBooking(String user_id, String bookingID) async {
    final db = await database;

    List<Map> ticket = await db.rawQuery('''
     DELETE FROM ferryticket where user_id =$user_id and book_id =$bookingID

     ''');

    return ticket;
  }

  Future<void> updateBooking(
      String user_id,
      String booking_id,
      String name,
      String surname,
      String phoneNumber,
      String date,
      String departLocation,
      String destLocation,
      String journeyType) async {
    final db = await database;

    String userUpdateQuery = "UPDATE User SET f_name" +
        "=" +
        "'" +
        name +
        "'" +
        "," +
        "l_name" +
        "=" +
        "'" +
        surname +
        "'" +
        "," +
        "mobilehp" +
        "=" +
        phoneNumber +
        " WHERE user_id " +
        "=" +
        user_id;
    var userUpdate = await db.rawQuery(userUpdateQuery);

    String deleteTicketQuery =
        "DELETE FROM FerryTicket Where book_id = $booking_id ";
    var ticketDelete = await db.rawQuery(deleteTicketQuery);

    if (journeyType == "") {
      journeyType = "With return ticket";
    }

    var SameTicket = new FerryTicket(
      bookId: int.parse(booking_id),
      departDate: DateTime.parse(date),
      journey: journeyType,
      departRoute: departLocation,
      destRoute: destLocation,
      userId: int.parse(user_id),
    );
    insertFerryTicket(SameTicket);

    print("Updated succesfully!");
  }

  void testFerryTicket() {
    var ticket = new FerryTicket(
      bookId: Random.secure().nextInt(200),
      departDate: DateTime.now(),
      journey: 'One Way',
      departRoute: 'Kuala Lumpur',
      destRoute: 'Singapore',
      userId: 1,
    );
    final DatabaseService db = DatabaseService();

    db.insertFerryTicket(ticket);
  }
}
