import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/screen/detail/favorite_icon_widget.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app/services/local_database_service.dart';

void main() {
  group('FavoriteIconWidget', () {
    late Restaurant mockRestaurant;

    setUp(() {
      mockRestaurant = Restaurant(
        id: 'test-id',
        name: 'Test Restaurant',
        description: 'Test description',
        pictureId: 'test-pic',
        city: 'Test City',
        rating: 4.0,
        categories: [],
        menus: Menus(foods: [], drinks: []),
        customerReviews: [],
      );
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => FavoriteIconProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => LocalDatabaseProvider(
                context.read<LocalDatabaseService>(),
              ),
            ),
            Provider(
              create: (context) => LocalDatabaseService(),
            ),
          ],
          child: Scaffold(
            body: FavoriteIconWidget(restaurant: mockRestaurant),
          ),
        ),
      );
    }

    testWidgets('should display favorite icon button', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
    });

    testWidgets('should have correct icon button properties', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNotNull);
    });

    testWidgets('should handle tap without crashing', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Act
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Assert - Should not crash
      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
