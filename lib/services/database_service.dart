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
    final path = join(databasePath, 'ferryservices.db');
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
    await db.execute(
      'CREATE TABLE user(user_id INTEGER PRIMARY KEY,f_name TEXT,l_name TEXT,username TEXT,password TEXT,mobilehp TEXT)',
    );

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
    List<Map> loginQuery = await db.query("user",
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

  Future<List<FerryTicket>> ferryTicket() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('ferryticket');
    return List.generate(maps.length, (index) => FerryTicket.fromMap(maps[index]));
  }

  Future<void> deleteBooking(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Remove the Brand from the database.
    await db.delete(
      'ferryticket',
      // Use a `where` clause to delete a specific brand.
      where: 'book_id = ?',
      // Pass the Brand's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> updateBooking(FerryTicket ferryticket) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Update the given brand
    await db.update(
      'ferryticket',
      ferryticket.toMap(),
      // Ensure that the Brand has a matching id.
      where: 'book_id = ?',
      // Pass the Brand's id as a whereArg to prevent SQL injection.
      whereArgs: [ferryticket.book_id],
    );
  }

  Future<User> user(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('user', where: 'user_id = ?', whereArgs: [id]);
    return User.fromMap(maps[0]);
  }
}
