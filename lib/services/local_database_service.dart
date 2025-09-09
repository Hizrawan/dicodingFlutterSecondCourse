import 'dart:convert';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static const String _databaseName = 'restaurant-app.db';
  static const String _tableName = 'restaurant';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE $_tableName(
       id TEXT PRIMARY KEY,
       name TEXT,
       description TEXT,
       pictureId TEXT,
       city TEXT,
       address TEXT,
       rating REAL,
       categories TEXT,
       menus TEXT,
       customerReviews TEXT
     )
     """);
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<String> insertItem(Restaurant restaurant) async {
    final db = await _initializeDb();
    
    final restaurantData = {
      "id": restaurant.id,
      "name": restaurant.name,
      "description": restaurant.description,
      "pictureId": restaurant.pictureId,
      "city": restaurant.city,
      "address": restaurant.address,
      "rating": restaurant.rating,
      "categories": jsonEncode(restaurant.categories.map((e) => e.toJson()).toList()),
      "menus": jsonEncode(restaurant.menus.toJson()),
      "customerReviews": jsonEncode(restaurant.customerReviews.map((e) => e.toJson()).toList()),
    };
    
    await db.insert(
      _tableName,
      restaurantData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return restaurant.id;
  }

  Future<List<Restaurant>> getAllItems() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName);

    return results.map((result) => _convertMapToRestaurant(result)).toList();
  }

  Future<Restaurant?> getItemById(String id) async {
    final db = await _initializeDb();
    final results = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    return results.isEmpty ? null : _convertMapToRestaurant(results.first);
  }

  Future<int> removeItem(String id) async {
    final db = await _initializeDb();

    final result = await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  Restaurant _convertMapToRestaurant(Map<String, dynamic> map) {
    return Restaurant(
      id: map["id"]?.toString() ?? "",
      name: map["name"]?.toString() ?? "",
      description: map["description"]?.toString() ?? "",
      pictureId: map["pictureId"]?.toString() ?? "",
      city: map["city"]?.toString() ?? "",
      address: map["address"]?.toString(),
      rating: (map["rating"] as num?)?.toDouble() ?? 0.0,
      categories: _parseCategories(map["categories"]),
      menus: _parseMenus(map["menus"]),
      customerReviews: _parseCustomerReviews(map["customerReviews"]),
    );
  }

  List<Category> _parseCategories(String? categoriesJson) {
    if (categoriesJson == null || categoriesJson.isEmpty) return [];
    try {
      final List<dynamic> categoriesList = jsonDecode(categoriesJson);
      return categoriesList.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Menus _parseMenus(String? menusJson) {
    if (menusJson == null || menusJson.isEmpty) {
      return Menus(foods: [], drinks: []);
    }
    try {
      final Map<String, dynamic> menusMap = jsonDecode(menusJson);
      return Menus.fromJson(menusMap);
    } catch (e) {
      return Menus(foods: [], drinks: []);
    }
  }

  List<CustomerReview> _parseCustomerReviews(String? reviewsJson) {
    if (reviewsJson == null || reviewsJson.isEmpty) return [];
    try {
      final List<dynamic> reviewsList = jsonDecode(reviewsJson);
      return reviewsList.map((e) => CustomerReview.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
