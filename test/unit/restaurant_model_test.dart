import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

void main() {
  group('Restaurant Model', () {
    test('should create Restaurant from valid JSON', () {
      // Arrange
      final json = {
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
        "pictureId": "14",
        "city": "Medan",
        "address": "Jl. Test No. 123",
        "rating": 4.2,
        "categories": [
          {"name": "Italia"},
          {"name": "Modern"}
        ],
        "menus": {
          "foods": [
            {"name": "Paket rosemary"},
            {"name": "Spaghetti Carbonara"}
          ],
          "drinks": [
            {"name": "Es krim"},
            {"name": "Cappuccino"}
          ]
        },
        "customerReviews": [
          {
            "name": "Ahmad",
            "review": "Tidak rekomendasi untuk pelajar!",
            "date": "13 November 2019"
          },
          {
            "name": "Siti",
            "review": "Makanan enak dan pelayanan ramah",
            "date": "14 November 2019"
          }
        ]
      };

      // Act
      final restaurant = Restaurant.fromJson(json);

      // Assert
      expect(restaurant.id, "rqdv5juczeskfw1e867");
      expect(restaurant.name, "Melting Pot");
      expect(restaurant.description, "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.");
      expect(restaurant.pictureId, "14");
      expect(restaurant.city, "Medan");
      expect(restaurant.address, "Jl. Test No. 123");
      expect(restaurant.rating, 4.2);
      expect(restaurant.categories.length, 2);
      expect(restaurant.categories.first.name, "Italia");
      expect(restaurant.menus.foods.length, 2);
      expect(restaurant.menus.drinks.length, 2);
      expect(restaurant.customerReviews.length, 2);
      expect(restaurant.customerReviews.first.name, "Ahmad");
    });

    test('should handle null values in JSON', () {
      // Arrange
      final json = {
        "id": "test-id",
        "name": "Test Restaurant",
        "description": "Test description",
        "pictureId": "test-pic",
        "city": "Test City",
        "rating": 3.5,
        "categories": [],
        "menus": {"foods": [], "drinks": []},
        "customerReviews": []
      };

      // Act
      final restaurant = Restaurant.fromJson(json);

      // Assert
      expect(restaurant.id, "test-id");
      expect(restaurant.name, "Test Restaurant");
      expect(restaurant.address, isNull);
      expect(restaurant.categories, isEmpty);
      expect(restaurant.menus.foods, isEmpty);
      expect(restaurant.menus.drinks, isEmpty);
      expect(restaurant.customerReviews, isEmpty);
    });

    test('should convert Restaurant to JSON correctly', () {
      // Arrange
      final restaurant = Restaurant(
        id: "test-id",
        name: "Test Restaurant",
        description: "Test description",
        pictureId: "test-pic",
        city: "Test City",
        address: "Test Address",
        rating: 4.0,
        categories: [
          Category(name: "Italian"),
          Category(name: "Modern")
        ],
        menus: Menus(
          foods: [
            MenuItem(name: "Pizza"),
            MenuItem(name: "Pasta")
          ],
          drinks: [
            MenuItem(name: "Coffee"),
            MenuItem(name: "Tea")
          ],
        ),
        customerReviews: [
          CustomerReview(
            name: "John",
            review: "Great food!",
            date: "2023-01-01"
          )
        ],
      );

      // Act
      final json = restaurant.toJson();

      // Assert
      expect(json["id"], "test-id");
      expect(json["name"], "Test Restaurant");
      expect(json["description"], "Test description");
      expect(json["pictureId"], "test-pic");
      expect(json["city"], "Test City");
      expect(json["address"], "Test Address");
      expect(json["rating"], 4.0);
      expect(json["categories"], isA<List>());
      expect(json["menus"], isA<Map>());
      expect(json["customerReviews"], isA<List>());
    });

    test('should generate correct image URL', () {
      // Arrange
      final restaurant = Restaurant(
        id: "test-id",
        name: "Test Restaurant",
        description: "Test description",
        pictureId: "test-pic",
        city: "Test City",
        rating: 4.0,
        categories: [],
        menus: Menus(foods: [], drinks: []),
        customerReviews: [],
      );

      // Act & Assert
      expect(restaurant.imageUrl, "https://restaurant-api.dicoding.dev/images/large/test-pic");
    });
  });

  group('Category Model', () {
    test('should create Category from JSON', () {
      // Arrange
      final json = {"name": "Italian"};

      // Act
      final category = Category.fromJson(json);

      // Assert
      expect(category.name, "Italian");
    });

    test('should convert Category to JSON', () {
      // Arrange
      final category = Category(name: "Italian");

      // Act
      final json = category.toJson();

      // Assert
      expect(json["name"], "Italian");
    });
  });

  group('Menus Model', () {
    test('should create Menus from JSON', () {
      // Arrange
      final json = {
        "foods": [
          {"name": "Pizza"},
          {"name": "Pasta"}
        ],
        "drinks": [
          {"name": "Coffee"},
          {"name": "Tea"}
        ]
      };

      // Act
      final menus = Menus.fromJson(json);

      // Assert
      expect(menus.foods.length, 2);
      expect(menus.drinks.length, 2);
      expect(menus.foods.first.name, "Pizza");
      expect(menus.drinks.first.name, "Coffee");
    });

    test('should handle empty menus in JSON', () {
      // Arrange
      final json = {"foods": [], "drinks": []};

      // Act
      final menus = Menus.fromJson(json);

      // Assert
      expect(menus.foods, isEmpty);
      expect(menus.drinks, isEmpty);
    });
  });

  group('MenuItem Model', () {
    test('should create MenuItem from JSON', () {
      // Arrange
      final json = {"name": "Pizza"};

      // Act
      final menuItem = MenuItem.fromJson(json);

      // Assert
      expect(menuItem.name, "Pizza");
    });

    test('should convert MenuItem to JSON', () {
      // Arrange
      final menuItem = MenuItem(name: "Pizza");

      // Act
      final json = menuItem.toJson();

      // Assert
      expect(json["name"], "Pizza");
    });
  });

  group('CustomerReview Model', () {
    test('should create CustomerReview from JSON', () {
      // Arrange
      final json = {
        "name": "John Doe",
        "review": "Great food and service!",
        "date": "2023-01-01"
      };

      // Act
      final review = CustomerReview.fromJson(json);

      // Assert
      expect(review.name, "John Doe");
      expect(review.review, "Great food and service!");
      expect(review.date, "2023-01-01");
    });

    test('should convert CustomerReview to JSON', () {
      // Arrange
      final review = CustomerReview(
        name: "John Doe",
        review: "Great food and service!",
        date: "2023-01-01"
      );

      // Act
      final json = review.toJson();

      // Assert
      expect(json["name"], "John Doe");
      expect(json["review"], "Great food and service!");
      expect(json["date"], "2023-01-01");
    });
  });
}
