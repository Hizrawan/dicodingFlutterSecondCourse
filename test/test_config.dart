// Test configuration and utilities for the restaurant app tests

import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

/// Test configuration class containing common test data and utilities
class TestConfig {
  // Common test timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 5);
  static const Duration longTimeout = Duration(seconds: 60);

  // Test data
  static Restaurant get mockRestaurant => Restaurant(
        id: 'test-restaurant-id',
        name: 'Test Restaurant',
        description: 'This is a test restaurant for unit testing purposes.',
        pictureId: 'test-picture-id',
        city: 'Test City',
        address: '123 Test Street, Test City',
        rating: 4.5,
        categories: [
          Category(name: 'Italian'),
          Category(name: 'Modern'),
        ],
        menus: Menus(
          foods: [
            MenuItem(name: 'Test Pizza'),
            MenuItem(name: 'Test Pasta'),
          ],
          drinks: [
            MenuItem(name: 'Test Coffee'),
            MenuItem(name: 'Test Tea'),
          ],
        ),
        customerReviews: [
          CustomerReview(
            name: 'Test User',
            review: 'This is a test review for testing purposes.',
            date: '2023-01-01',
          ),
        ],
      );

  static Restaurant get mockRestaurant2 => Restaurant(
        id: 'test-restaurant-id-2',
        name: 'Test Restaurant 2',
        description: 'This is another test restaurant for unit testing purposes.',
        pictureId: 'test-picture-id-2',
        city: 'Test City 2',
        address: '456 Test Avenue, Test City 2',
        rating: 4.0,
        categories: [
          Category(name: 'Asian'),
          Category(name: 'Traditional'),
        ],
        menus: Menus(
          foods: [
            MenuItem(name: 'Test Sushi'),
            MenuItem(name: 'Test Ramen'),
          ],
          drinks: [
            MenuItem(name: 'Test Green Tea'),
            MenuItem(name: 'Test Sake'),
          ],
        ),
        customerReviews: [
          CustomerReview(
            name: 'Test User 2',
            review: 'This is another test review for testing purposes.',
            date: '2023-01-02',
          ),
        ],
      );

  static List<Restaurant> get mockRestaurantList => [
        mockRestaurant,
        mockRestaurant2,
      ];

  // API response mocks
  static Map<String, dynamic> get mockRestaurantListResponse => {
        'error': false,
        'message': 'success',
        'count': 2,
        'restaurants': [
          {
            'id': 'test-restaurant-id',
            'name': 'Test Restaurant',
            'description': 'This is a test restaurant for unit testing purposes.',
            'pictureId': 'test-picture-id',
            'city': 'Test City',
            'address': '123 Test Street, Test City',
            'rating': 4.5,
            'categories': [
              {'name': 'Italian'},
              {'name': 'Modern'},
            ],
            'menus': {
              'foods': [
                {'name': 'Test Pizza'},
                {'name': 'Test Pasta'},
              ],
              'drinks': [
                {'name': 'Test Coffee'},
                {'name': 'Test Tea'},
              ],
            },
            'customerReviews': [
              {
                'name': 'Test User',
                'review': 'This is a test review for testing purposes.',
                'date': '2023-01-01',
              },
            ],
          },
          {
            'id': 'test-restaurant-id-2',
            'name': 'Test Restaurant 2',
            'description': 'This is another test restaurant for unit testing purposes.',
            'pictureId': 'test-picture-id-2',
            'city': 'Test City 2',
            'address': '456 Test Avenue, Test City 2',
            'rating': 4.0,
            'categories': [
              {'name': 'Asian'},
              {'name': 'Traditional'},
            ],
            'menus': {
              'foods': [
                {'name': 'Test Sushi'},
                {'name': 'Test Ramen'},
              ],
              'drinks': [
                {'name': 'Test Green Tea'},
                {'name': 'Test Sake'},
              ],
            },
            'customerReviews': [
              {
                'name': 'Test User 2',
                'review': 'This is another test review for testing purposes.',
                'date': '2023-01-02',
              },
            ],
          },
        ],
      };

  static Map<String, dynamic> get mockRestaurantDetailResponse => {
        'error': false,
        'message': 'success',
        'restaurant': {
          'id': 'test-restaurant-id',
          'name': 'Test Restaurant',
          'description': 'This is a test restaurant for unit testing purposes.',
          'pictureId': 'test-picture-id',
          'city': 'Test City',
          'address': '123 Test Street, Test City',
          'rating': 4.5,
          'categories': [
            {'name': 'Italian'},
            {'name': 'Modern'},
          ],
          'menus': {
            'foods': [
              {'name': 'Test Pizza'},
              {'name': 'Test Pasta'},
            ],
            'drinks': [
              {'name': 'Test Coffee'},
              {'name': 'Test Tea'},
            ],
          },
          'customerReviews': [
            {
              'name': 'Test User',
              'review': 'This is a test review for testing purposes.',
              'date': '2023-01-01',
            },
          ],
        },
      };

  static Map<String, dynamic> get mockErrorResponse => {
        'error': true,
        'message': 'Test error message',
      };

  // Test utilities
  static void expectRestaurantEquals(Restaurant actual, Restaurant expected) {
    expect(actual.id, expected.id);
    expect(actual.name, expected.name);
    expect(actual.description, expected.description);
    expect(actual.pictureId, expected.pictureId);
    expect(actual.city, expected.city);
    expect(actual.address, expected.address);
    expect(actual.rating, expected.rating);
    expect(actual.categories.length, expected.categories.length);
    expect(actual.menus.foods.length, expected.menus.foods.length);
    expect(actual.menus.drinks.length, expected.menus.drinks.length);
    expect(actual.customerReviews.length, expected.customerReviews.length);
  }

  static void expectCategoryEquals(Category actual, Category expected) {
    expect(actual.name, expected.name);
  }

  static void expectMenuItemEquals(MenuItem actual, MenuItem expected) {
    expect(actual.name, expected.name);
  }

  static void expectCustomerReviewEquals(CustomerReview actual, CustomerReview expected) {
    expect(actual.name, expected.name);
    expect(actual.review, expected.review);
    expect(actual.date, expected.date);
  }
}

/// Test matchers for common assertions
class TestMatchers {
  static Matcher isRestaurant() => isA<Restaurant>();
  static Matcher isCategory() => isA<Category>();
  static Matcher isMenuItem() => isA<MenuItem>();
  static Matcher isCustomerReview() => isA<CustomerReview>();
  static Matcher isMenus() => isA<Menus>();
}

/// Test constants
class TestConstants {
  static const String testRestaurantId = 'test-restaurant-id';
  static const String testRestaurantName = 'Test Restaurant';
  static const String testCity = 'Test City';
  static const double testRating = 4.5;
  static const String testCategoryName = 'Italian';
  static const String testMenuItemName = 'Test Pizza';
  static const String testReviewName = 'Test User';
  static const String testReviewText = 'This is a test review for testing purposes.';
  static const String testDate = '2023-01-01';
}
