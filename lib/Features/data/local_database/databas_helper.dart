import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tv_shows_appp/Features/model/cast_model.dart';
import 'package:tv_shows_appp/Features/model/show_model.dart';

abstract class DatabaseHelper {
  static createDatabaseAndTables() async {
    // Avoid errors caused by flutter upgrade.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    openDatabase(
      // Set the path to the database
      join(await getDatabasesPath(), 'shows_database.db'),

      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute(
          'CREATE TABLE shows('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' show_id INTEGER,'
              ' name TEXT,'
              ' image TEXT,'
              ' summary TEXT,'
              ' genreList TEXT,'
              ' status TEXT,'
              ' premiereDate TEXT,'
              ' time TEXT,'
              ' network TEXT,'
              ' ratings TEXT,'
              ' daysList TEXT,'
              ' genreNames TEXT)',
        );

        return db.execute(
          'CREATE TABLE cast('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' cast_id INTEGER,'
              ' show_id INTEGER,'
              ' name TEXT,'
              ' image TEXT,'
              ' character TEXT)',
        );
      },

      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  static Future<Database> createDatabaseConnection() async {
    return openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'shows_database.db'),
    );
  }

  /// inserts or update [show] from the shows table
  /// check for existing records/update by [showId]
  static Future<void> insertOrUpdateShows({
    required ShowModel show,
    required int showId,
  }) async {
    try {
      // create a DB connection
      // Get a reference to the database.
      final db = await createDatabaseConnection();

      // check if a records exists to decide whether to update or insert
      final List<Map<String, dynamic>> maps = await db.query(
        'shows',
        where: 'show_id = ?',
        whereArgs: [showId],
      );

      // if the list is not empty, update the table
      // else insert a new record
      if (maps.isNotEmpty) {
        // In this case, replace any previous data.
        await db.update(
          'shows',
          show.toMap(),
          // Ensure that the show has a matching id.
          where: 'show_id = ?',
          // Pass the id as a whereArg to prevent SQL injection.
          whereArgs: [showId],
        );
      } else {
        // Insert the data into the correct table. You might also specify the
        // `conflictAlgorithm` to use in case the same data is inserted twice.
        //
        // In this case, replace any previous data.
        await db.insert(
          'shows',
          show.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } on Exception catch (e) {
      throw (e);
    }
  }

  /// inserts or update [cast] and [showId] from the cast table
  /// check for existing records/update by [castId]
  static Future<void> insertOrUpdateCast({
    required CastModel cast,
    required int castId,
    required int showId,
  }) async {
    try {
      // create a DB connection
      // Get a reference to the database.
      final db = await createDatabaseConnection();

      // check if a records exists to decide whether to update or insert
      final List<Map<String, dynamic>> maps = await db.query(
        'cast',
        where: 'cast_id = ?',
        whereArgs: [castId],
      );

      // if the list is not empty, update the table
      // else insert a new record
      if (maps.isNotEmpty) {
        // In this case, replace any previous data.
        await db.update(
          'cast',
          cast.toMap(),
          // Ensure that the show has a matching id.
          where: 'cast_id = ?',
          // Pass the id as a whereArg to prevent SQL injection.
          whereArgs: [castId],
        );
      } else {
        // Insert the data into the correct table. You might also specify the
        // `conflictAlgorithm` to use in case the same data is inserted twice.
        //
        // In this case, replace any previous data.
        await db.insert(
          'cast',
          cast.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<ShowModel>> getLocalShows({
    int limit = 1,
    int? offset,
  }) async {
    // create a DB connection
    // Get a reference to the database.
    final db = await createDatabaseConnection();

    // Query the table for all the dogs.
    // LIMIT: how many rows to fetch
    // OFFSET: how many rows to skip
    final List<Map<String, Object?>> showsMaps = await db.rawQuery(
      'SELECT * FROM shows',
    );
    // debugPrint("Data from db is ${showsMaps.length}");

    return _formatDataFromDB(showsMaps: showsMaps);
  }

  /// search for matching shows by show name
  /// [searchTerm] query parameter
  static Future<List<ShowModel>> searchLocalShows({
    required String searchTerm,
  }) async {
    // create a DB connection
    // Get a reference to the database.
    final db = await createDatabaseConnection();

    // Query the table for matching shows.
    final List<Map<String, Object?>> showsMaps = await await db.query(
      'shows',
      // Define the WHERE clause using the LIKE operator for searching
      where: "name LIKE ?",
      // Pass the search term as an argument, ensuring '%' is part of the string here
      whereArgs: ['%$searchTerm%'],
    );

    return _formatDataFromDB(showsMaps: showsMaps);
  }

  /// format shows data from the Database
  /// [showsMaps] is a list of [ShowModel]
  static Future<List<ShowModel>> _formatDataFromDB({
    required List<Map<String, Object?>> showsMaps,
  }) async {
    // Convert the list of each show's fields into a list of `ShowModel` objects.
    return [
      for (final {
      'show_id': id as int,
      'name': name as String,
      'image': image as String,
      'summary': summary as String,
      'genreList': genreList as String,
      'status': status as String,
      'premiereDate': premiereDate as String,
      'time': time as String,
      'network': network as String,
      'ratings': ratings as String,
      'daysList': daysList as String,
      'genreNames': genreNames as String,
      }
      in showsMaps)
        ShowModel(
          id: id,
          name: name,
          image: image,
          summary: summary,
          genreList: jsonDecode(genreList) ?? {},
          status: status,
          premiereDate: premiereDate,
          time: time,
          network: network,
          ratings: ratings,
          daysList: jsonDecode(daysList) ?? {},
          genreNames: genreNames,
        ),
    ];
  }

  /// get cast from database matching id [showId]
  static Future<List<CastModel>> getLocalCast({required int showId}) async {
    // create a DB connection
    // Get a reference to the database.
    final db = await createDatabaseConnection();

    final List<Map<String, Object?>> castMaps = await await db.query(
      'cast',
      where: "show_id = ?",
      whereArgs: [showId],
    );

    debugPrint("Cast data from db is ${castMaps.length}");

    // Convert the list of each show's fields into a list of `CastModel` objects.
    return [
      for (final {
      'cast_id': id as int,
      'show_id': showId as int,
      'name': name as String,
      'image': image as String,
      'character': character as String,
      }
      in castMaps)
        CastModel(
          id: id,
          name: name,
          image: image,
          character: character,
          showId: showId,
        ),
    ];
  }
}