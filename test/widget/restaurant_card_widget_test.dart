import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

void main() {
  group('RestaurantCard Widget', () {
    late Restaurant mockRestaurant;

    setUp(() {
      mockRestaurant = Restaurant(
        id: 'test-id',
        name: 'Test Restaurant',
        description: 'Test description',
        pictureId: 'test-pic',
        city: 'Test City',
        address: 'Test Address',
        rating: 4.5,
        categories: [
          Category(name: 'Italian'),
          Category(name: 'Modern')
        ],
        menus: Menus(
          foods: [
            MenuItem(name: 'Pizza'),
            MenuItem(name: 'Pasta')
          ],
          drinks: [
            MenuItem(name: 'Coffee'),
            MenuItem(name: 'Tea')
          ],
        ),
        customerReviews: [
          CustomerReview(
            name: 'John',
            review: 'Great food!',
            date: '2023-01-01'
          )
        ],
      );
    });

    testWidgets('should display restaurant information correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: mockRestaurant),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Restaurant'), findsOneWidget);
      expect(find.text('Test City'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should display correct image URL', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: mockRestaurant),
          ),
        ),
      );

      // Assert
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, isA<NetworkImage>());
      final networkImage = imageWidget.image as NetworkImage;
      expect(networkImage.url, 'https://restaurant-api.dicoding.dev/images/large/test-pic');
    });

    testWidgets('should have correct Hero tag', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: mockRestaurant),
          ),
        ),
      );

      // Assert
      final heroWidget = tester.widget<Hero>(find.byType(Hero));
      expect(heroWidget.tag, 'test-id');
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      // Arrange
      bool onTapCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(
              restaurant: mockRestaurant,
              onTap: () {
                onTapCalled = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Assert
      expect(onTapCalled, isTrue);
    });

    testWidgets('should not crash when onTap is null', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: mockRestaurant),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Assert - should not throw any exception
      expect(find.byType(RestaurantCard), findsOneWidget);
    });

    testWidgets('should display star icon with correct color', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: mockRestaurant),
          ),
        ),
      );

      // Assert
      final starIcon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(starIcon.color, const Color(0xFFFFC107));
      expect(starIcon.size, 16);
    });

    testWidgets('should handle long restaurant names', (WidgetTester tester) async {
      // Arrange
      final longNameRestaurant = Restaurant(
        id: 'test-id',
        name: 'This is a very long restaurant name that should be handled properly',
        description: 'Test description',
        pictureId: 'test-pic',
        city: 'Test City',
        rating: 4.0,
        categories: [],
        menus: Menus(foods: [], drinks: []),
        customerReviews: [],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: longNameRestaurant),
          ),
        ),
      );

      // Assert
      expect(find.text('This is a very long restaurant name that should be handled properly'), findsOneWidget);
    });

    testWidgets('should handle long city names', (WidgetTester tester) async {
      // Arrange
      final longCityRestaurant = Restaurant(
        id: 'test-id',
        name: 'Test Restaurant',
        description: 'Test description',
        pictureId: 'test-pic',
        city: 'This is a very long city name that should be handled properly',
        rating: 4.0,
        categories: [],
        menus: Menus(foods: [], drinks: []),
        customerReviews: [],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: longCityRestaurant),
          ),
        ),
      );

      // Assert
      expect(find.text('This is a very long city name that should be handled properly'), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: mockRestaurant),
          ),
        ),
      );

      // Assert
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(ConstrainedBox), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(Hero), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });
  });
}
